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
- Compression support

### Advantages

1. **Copy-on-Write (CoW)**
   - Efficient snapshots (instant, space-efficient)
   - Data never overwritten (safer against corruption)
   - Perfect for NixOS generations (many similar system states)

2. **Checksumming**
   - Silent corruption detection on every data block
   - Corruption detected on read

3. **Transparent Compression**
   - Reduces disk usage (especially for the Nix store)
   - Often improves performance (less I/O)
   - Algorithm: `zstd` (good ratio and speed)

4. **Subvolumes**
   - Separate filesystem trees within one partition
   - Different mount options per subvolume
   - Selective snapshots (e.g., snapshot `/home` separately)

5. **Online Maintenance**
   - Resize, defragment, and balance while mounted
   - No downtime required

### Synergy with NixOS

NixOS generates many similar files across generations. Btrfs CoW deduplication, compression, and efficient snapshots all complement NixOS's store-heavy model:
- Compression: 20–40% size reduction typical
- Fast snapshots of entire system states
- Subvolumes separate system and user data

## Alternatives Considered

### ext4
- **Pros:** Battle-tested, simple, universal support
- **Cons:** No snapshots, no compression, no checksums, no CoW
- **Rejected:** Missing modern features

### XFS
- **Pros:** Excellent performance for large files
- **Cons:** No snapshots, no checksums, limited shrink support
- **Rejected:** Fewer features than Btrfs

### ZFS
- **Pros:** Feature-rich, excellent data integrity
- **Cons:** Licensing issues (not in mainline kernel), higher memory usage
- **Rejected:** Legal uncertainty, complexity overkill for desktop

### bcachefs
- **Pros:** Modern design, promising features
- **Cons:** Very new, limited tooling
- **Rejected:** Too early, wait for maturity

## Consequences

### Positive
- Automatic compression saves disk space
- Checksums catch silent corruption
- Regular automated maintenance (scrub, balance, trim)
- Efficient storage for multiple NixOS generations

### Negative
- More complex than ext4
- Certain workloads slower (many small random writes)
- Need regular maintenance (automated via `core/nix/btrfs.nix`)
- Learning curve for Btrfs-specific tools

## Implementation

### Subvolume Layout

```
/ (top-level volume)
├── @        (root subvolume, mounted at /)
├── @home    (home subvolume, mounted at /home)
├── @nix     (Nix store subvolume, mounted at /nix)
└── @snapshots
```

Benefits:
- Independent snapshots per subvolume
- Different mount options per subvolume
- `/nix` can be excluded from backups (fully reproducible)

### Mount Options

```nix
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

- `compress=zstd`: Transparent compression
- `noatime`: Don't update access times (performance)

### Automated Maintenance

Configured in `core/nix/btrfs.nix`:

```nix
# Weekly scrub (data integrity check)
services.btrfs.autoScrub = {
  enable = true;
  interval = "weekly";
  fileSystems = [ "/" ];
};

# Weekly balance (space optimization, skipped on battery)
systemd.services."btrfs-balance" = {
  script = ''
    btrfs balance start -dusage=75 -musage=75 /
  '';
};

# Weekly trim (SSD space reclaim)
services.fstrim = {
  enable = true;
  interval = "weekly";
};
```

## Best Practices

### Regular Maintenance

All of the following run automatically (weekly) via the configuration:
1. **Scrub** — verify data integrity, detect silent corruption
2. **Balance** — redistribute data, prevent metadata full errors
3. **Trim** — reclaim space on SSDs

### Snapshot Strategy

```bash
# Before major updates
sudo btrfs subvolume snapshot / /.snapshots/root-$(date +%Y%m%d)

# After verifying
sudo btrfs subvolume delete /.snapshots/root-YYYYMMDD
```

### Monitoring

```bash
sudo btrfs device stats /
btrfs filesystem df /
btrfs filesystem usage /
```

## Known Limitations

- Swap files require special setup (disable CoW, or use swap partition)
- CoW can cause fragmentation for databases/VMs (use `nodatacow` for those)
- Can run out of metadata space while data space shows available (fixed by balance)

## Troubleshooting

### "No space left on device" but df shows space

```bash
# Metadata is likely full
btrfs filesystem usage /
sudo btrfs balance start -dusage=50 /
```

### Corruption Detected

```bash
sudo btrfs scrub start /
sudo btrfs scrub status /
```

## Review

This decision should be reviewed if:
- Major Btrfs stability issues discovered
- bcachefs or another filesystem matures significantly
- Workload changes to database/VM heavy use
- RAID requirements emerge

## References

- [Btrfs Wiki](https://btrfs.wiki.kernel.org/)
- [Arch Wiki - Btrfs](https://wiki.archlinux.org/title/Btrfs)
- [NixOS Wiki - Btrfs](https://nixos.wiki/wiki/Btrfs)
