# ADR 0005: Btrfs Filesystem

**Status:** Accepted

**Date:** 2024

## Context

Modern Linux systems support multiple filesystems (ext4, XFS, Btrfs, ZFS). For a NixOS system that uses generations and frequent system rebuilds, we needed a filesystem that provides good performance, reliability, and features that complement NixOS's architecture.

## Decision

We will use Btrfs (B-tree filesystem) as the primary filesystem for this configuration.

## Rationale

### What is Btrfs?

Btrfs is a modern copy-on-write (CoW) filesystem with:
- Built-in snapshots and subvolumes
- Data integrity checking (checksums)
- Online defragmentation and resizing
- Built-in RAID support
- Compression support
- Self-healing with redundant copies

### Advantages

1. **Copy-on-Write (CoW)**
   - Efficient snapshots (instant, space-efficient)
   - Data never overwritten (safer against corruption)
   - Perfect for NixOS generations (many similar system states)

2. **Snapshots**
   - Can snapshot before system updates
   - Easy rollback if update breaks system
   - Complementary to NixOS generations
   - Nearly instant, minimal space overhead

3. **Checksumming**
   - Silent corruption detection
   - Every data block checksummed
   - Corruption detected on read
   - Can self-heal with RAID

4. **Transparent Compression**
   - Reduce disk usage (especially for Nix store)
   - Often improves performance (less I/O)
   - Algorithms: zstd (default), lzo, zlib
   - Applied automatically to all writes

5. **Subvolumes**
   - Separate filesystem trees within one partition
   - Different mount options per subvolume
   - Selective snapshots (e.g., snapshot `/home` separately)
   - Easier backup strategies

6. **Online Maintenance**
   - Resize while mounted
   - Defragmentation while in use
   - Balance (redistribute data) online
   - No downtime required

7. **Mature in Kernel**
   - Part of mainline Linux kernel
   - Active development
   - Wide hardware support
   - Proven in production (Facebook, SUSE, others)

### Synergy with NixOS

**NixOS generates many similar files:**
- Multiple kernel versions
- Multiple package versions
- System generations share most files

**Btrfs CoW helps:**
- Deduplication saves space
- Fast snapshots of entire system states
- Compression reduces Nix store bloat
- Subvolumes separate system/user data

**Typical space savings:**
- Compression: 20-40% reduction
- CoW deduplication: Varies (5-15% typical)
- Combined: Can save 100+ GB on large systems

## Alternatives Considered

### ext4
- **Pros:** Battle-tested, simple, fast, universal support
- **Cons:** No snapshots, no compression, no checksums, no CoW
- **Rejected:** Missing modern features we want to leverage

### XFS
- **Pros:** Excellent performance, stable, good for large files
- **Cons:** No snapshots, no checksums, limited shrink support
- **Rejected:** Fewer features than Btrfs, not much faster in practice

### ZFS
- **Pros:** Feature-rich, excellent data integrity, mature, battle-tested
- **Cons:** Licensing issues (not in kernel), more complex, higher memory usage
- **Rejected:** Legal uncertainty, complexity overkill for desktop use

### F2FS
- **Pros:** Optimized for flash storage, good performance
- **Cons:** Fewer features, less mature, primarily for mobile/embedded
- **Rejected:** Too specialized, less proven on desktop

### bcachefs
- **Pros:** Modern design, promising features, fast
- **Cons:** Very new, not yet stable, limited tooling, in development
- **Rejected:** Too early, wait for maturity

## Consequences

### Positive
- Automatic compression saves disk space
- Snapshots provide additional safety layer
- Checksums catch silent corruption
- Regular scrubs ensure data integrity
- Efficient storage for multiple NixOS generations

### Negative
- More complex than ext4 (more failure modes)
- Certain workloads slower (many small random writes)
- Need regular maintenance (scrub, balance)
- Cannot shrink filesystem in all cases
- Learning curve for Btrfs-specific tools

### Neutral
- Different tooling (`btrfs` command vs `resize2fs`, etc.)
- Need to understand CoW behavior
- Backup strategies differ from traditional filesystems

## Implementation

### Subvolume Layout

```
/ (top-level volume)
├── @ (root subvolume, mounted at /)
├── @home (home subvolume, mounted at /home)
├── @nix (Nix store subvolume, mounted at /nix)
└── @snapshots (snapshot storage)
```

Benefits:
- Separate snapshots for system vs user data
- Different mount options per subvolume
- Exclude @nix from backups (reproducible)

### Mount Options

```nix
# system/nix/btrfs.nix
fileSystems."/" = {
  options = [ "compress=zstd" "noatime" ];
};

fileSystems."/home" = {
  options = [ "compress=zstd" "noatime" ];
};

fileSystems."/nix" = {
  options = [ "compress=zstd" "noatime" ];
};
```

- `compress=zstd`: Transparent compression (good ratio & speed)
- `noatime`: Don't update access times (performance)

### Automated Maintenance

```nix
# Weekly scrub (data integrity check)
services.btrfs.autoScrub = {
  enable = true;
  interval = "weekly";
  fileSystems = [ "/" ];
};

# Monthly balance (space optimization)
systemd.services.btrfs-balance = {
  script = ''
    ${pkgs.btrfs-progs}/bin/btrfs balance start -dusage=75 /
  '';
  startAt = "monthly";
};
```

**Scrub:**
- Reads all data and verifies checksums
- Reports corruption if found
- Can self-heal with redundant copies

**Balance:**
- Redistributes data across devices
- Reclaims space from CoW operations
- Prevents "out of space" when metadata full

## Best Practices

### Regular Maintenance

1. **Weekly Scrub**
   - Verify data integrity
   - Catch silent corruption early
   - Run when system is idle (I/O intensive)

2. **Monthly Balance**
   - When on AC power (for laptops)
   - Use `-dusage=75` to avoid full rebalance
   - Monitor free space

3. **Monthly Defrag** (optional)
   - For frequently modified files
   - Not needed for Nix store (write-once)
   - Use `-czstd` to recompress

4. **Check Free Space**
   ```bash
   btrfs filesystem usage /
   ```
   Monitor metadata usage separately from data.

### Snapshot Strategy

```bash
# Before major updates
sudo btrfs subvolume snapshot / /.snapshots/root-$(date +%Y%m%d)

# After verifying update
sudo btrfs subvolume delete /.snapshots/root-20240101
```

**When to snapshot:**
- Before major system updates
- Before risky configuration changes
- Weekly/daily for user data (`/home`)

**Retention:**
- Keep last 5-10 system snapshots
- Keep daily home snapshots for 1 week
- Keep weekly home snapshots for 1 month

### Monitoring

```bash
# Check filesystem health
sudo btrfs device stats /

# View space usage
btrfs filesystem df /

# Detailed usage breakdown
btrfs filesystem usage /
```

## Known Limitations

### RAID 5/6
- Btrfs RAID 5/6 has known issues
- RAID 1 and RAID 10 are stable
- For this config: Single device, no RAID

### Swap Files
- Swap files on Btrfs require special setup
- Must disable CoW for swap file
- Or use swap partition instead

### Fragmentation
- CoW can cause fragmentation over time
- Particularly for databases, VMs
- Mitigated by: nodatacow for specific files, periodic defrag

### Free Space Management
- Can run out of metadata space while data space available
- Mitigated by: regular balance operations

## Troubleshooting

### "No space left on device" but df shows space
```bash
# Check metadata usage
btrfs filesystem usage /

# Balance to reclaim space
sudo btrfs balance start -dusage=50 /
```

### Slow Performance
```bash
# Check fragmentation
sudo btrfs filesystem defragment -r /

# Enable autodefrag mount option
mount -o remount,autodefrag /
```

### Corruption Detected
```bash
# Scrub to identify issues
sudo btrfs scrub start /
sudo btrfs scrub status /

# If repairable
sudo btrfs check --repair /dev/sdX  # (unmounted)
```

## Performance Considerations

**Btrfs is fast for:**
- Sequential reads/writes
- Snapshot operations
- Compressed data
- Large files

**Btrfs is slower for:**
- Many small random writes
- Databases (use nodatacow)
- VMs (use nodatacow for disk images)

**For NixOS workload:**
- Mostly sequential writes (package installs)
- Many reads (program execution)
- Large files (packages, kernels)
- **Result: Good match**

## Review

This decision should be reviewed if:
- Major Btrfs stability issues discovered
- bcachefs or other filesystem matures significantly
- ZFS licensing situation resolves
- Workload changes to database/VM heavy
- RAID requirements emerge

## References

- [Btrfs Wiki](https://btrfs.wiki.kernel.org/)
- [Arch Wiki - Btrfs](https://wiki.archlinux.org/title/Btrfs)
- [NixOS Wiki - Btrfs](https://nixos.wiki/wiki/Btrfs)
- [SUSE Btrfs Guide](https://documentation.suse.com/sles/15-SP4/html/SLES-all/cha-filesystems.html)
