# Quick Reference Guide

Quick reference for common operations and tasks in this NixOS configuration.

## Table of Contents

- [System Management](#system-management)
- [Configuration Changes](#configuration-changes)
- [Module Management](#module-management)
- [Maintenance](#maintenance)
- [Troubleshooting](#troubleshooting)
- [Git Operations](#git-operations)

## System Management

### Rebuild Commands

```bash
# Apply changes and make bootable
sudo nixos-rebuild switch --flake .#{host}

# Apply changes temporarily (not added to bootloader)
sudo nixos-rebuild test --flake .#{host}

# Build only (don't apply)
sudo nixos-rebuild build --flake .#{host}

# Build and set for next boot only
sudo nixos-rebuild boot --flake .#{host}
```

### Using Aliases

If you have configured shell aliases (see `modules/shell/commonAliases.nix`):

```bash
os    # Quick rebuild (alias for nixos-rebuild switch)
ou    # Update flake inputs + rebuild
```

### Generation Management

```bash
# List all generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Switch to specific generation
sudo nix-env --switch-generation N --profile /nix/var/nix/profiles/system
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch

# Delete old generations
sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
sudo nix-env --delete-generations 14d --profile /nix/var/nix/profiles/system
```

## Configuration Changes

### Changing Theme

Edit `hosts/{host}/modules/userOptions.nix`:

```nix
config.userOptions = {
  colorScheme = "your-scheme-name";  # base16 scheme name
  wallpaper = "your-wallpaper.png";  # file in assets/wallpapers/
};
```

Browse available schemes at the [Tinted Theming Gallery](https://tinted-theming.github.io/base16-gallery/).

### Enabling/Disabling Programs

Edit `hosts/{host}/modules/programs.nix`:

```nix
{
  config = {
    programs = {
      gaming.enable = true;
      content.enable = false;
      dev.enable = true;
    };

    programs.dev.optionalPackages = [
      pkgs.some-tool
    ];
  };
}
```

### Adding Packages

#### One-time (Temporary)
```bash
nix shell nixpkgs#package-name
```

#### Via a Module's optionalPackages
```nix
# In hosts/{host}/modules/programs.nix
programs.dev.optionalPackages = [
  pkgs.package-name
];
```

#### System-wide (in a module)
```nix
environment.systemPackages = [ pkgs.package-name ];
```

### Changing Wallpaper

1. Add image to `assets/wallpapers/`
2. Update `hosts/{host}/modules/userOptions.nix`:
   ```nix
   config.userOptions.wallpaper = "new-wallpaper.png";
   ```
3. Rebuild

## Module Management

### Enable a Module

```nix
# In hosts/{host}/modules/programs.nix
programs.feature.enable = true;
```

### Create New Module

```bash
# 1. Create file
mkdir -p modules/applications/myapp
# Write modules/applications/myapp/default.nix

# 2. Write the module using the flake-parts wrapper pattern
# (see MODULE_GUIDE.md)

# 3. Enable in host config
# programs.myapp.enable = true;

# 4. Test
nix flake check
sudo nixos-rebuild test --flake .#{host}
```

No manual import step — `import-tree` discovers new files automatically.

## Maintenance

### Update Flake Inputs

```bash
# Update all inputs
nix flake update

# Update specific input
nix flake update nixpkgs

# Update and rebuild (using alias)
ou
```

### Garbage Collection

```bash
# Manual: remove unreachable store paths
nix-collect-garbage -d

# Manual: also remove system generations
sudo nix-collect-garbage -d
nix store optimise

# Check space
df -h /nix
```

Garbage collection is also automated (see `core/nix/gc.nix`).

### Btrfs Maintenance

```bash
# Check filesystem health
sudo btrfs device stats /

# Check space usage
btrfs filesystem df /
btrfs filesystem usage /

# Manual scrub (data integrity check)
sudo btrfs scrub start /
sudo btrfs scrub status /

# Manual balance (space optimization)
sudo btrfs balance start -dusage=75 /

# Trim SSD
sudo fstrim -av
```

Scrub, balance, and trim run automatically weekly via `core/nix/btrfs.nix`.

### Monitor Disk Usage

```bash
df -h
du -sh /nix/store
nix path-info -rsSh /run/current-system | sort -hk2 | tail -20
nix-env --list-generations --profile /nix/var/nix/profiles/system
```

## Troubleshooting

### Build Fails

```bash
# Check flake syntax
nix flake check

# Try with full trace
sudo nixos-rebuild switch --flake .#{host} --show-trace
```

### Service Not Starting

```bash
systemctl status service-name
journalctl -u service-name -f
journalctl -b
```

### Application Not Found

```bash
which app-name
nix search nixpkgs app-name
```

### Configuration Errors

```bash
# Rollback immediately
sudo nixos-rebuild switch --rollback

# Or select previous generation at boot menu
```

### Hyprland Issues

```bash
# Check logs
journalctl --user -u hyprland

# Check UWSM status
systemctl --user status uwsm@hyprland-uwsm.desktop.service

# Restart display manager (from TTY)
sudo systemctl restart display-manager
```

### Network Issues

```bash
systemctl status NetworkManager
sudo systemctl restart NetworkManager
journalctl -u NetworkManager
```

## Git Operations

### Commit Configuration Changes

```bash
git status
git diff
git add path/to/changed/files
git commit -m "feat: describe what you changed"
git push
```

### Commit Message Format

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add new feature
fix: resolve bug in module
docs: update documentation
refactor: reorganize module structure
chore: update dependencies
```

## Useful Commands

### System Information

```bash
nixos-version
lshw -short
lscpu
free -h
lsblk
ff    # fastfetch system summary
```

### Package Information

```bash
nix search nixpkgs package-name
nix eval nixpkgs#package-name.meta.description
nix eval nixpkgs#package-name.version
which package-name
```

### Process Management

```bash
ps aux
htop
kill PID
sudo lsof -i :PORT
```

## Quick Fixes

### "No space left on device" (Btrfs metadata full)

```bash
sudo btrfs balance start -dusage=50 /
sudo nix-collect-garbage -d
```

### Boot fails after update

1. Select previous generation at boot menu
2. Boot into working system
3. Check logs: `journalctl -b -1`
4. Fix issue or rollback: `sudo nixos-rebuild switch --rollback`

### Locked/broken flake

```bash
rm flake.lock
nix flake update
```

### Hyprland frozen

```bash
# From TTY (Ctrl+Alt+F2)
sudo systemctl restart display-manager
```

## Configuration Locations

```
~/dotfiles/                           # This repository
  ├── flake.nix                       # Flake definition
  ├── hosts/{host}/                   # Host configuration
  │   └── modules/
  │       ├── programs.nix            # Enabled programs
  │       └── userOptions.nix         # Theme, wallpaper, user settings
  ├── modules/                        # Feature modules
  ├── core/                           # Core system config
  └── assets/                         # Wallpapers and logos

/run/current-system/                  # Current system closure
/nix/var/nix/profiles/system          # System profile
/home/$USER/.config/                  # User configs (managed by Home Manager)
```

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Stylix Documentation](https://stylix.danth.me/)
- [Architecture Documentation](./ARCHITECTURE.md)
- [Module Guide](./MODULE_GUIDE.md)
- [Contributing](../CONTRIBUTING.md)
