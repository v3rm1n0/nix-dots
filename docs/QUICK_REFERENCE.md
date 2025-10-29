# Quick Reference Guide

Quick reference for common operations and tasks in this NixOS configuration.

## Table of Contents

- [System Management](#system-management)
- [Configuration Changes](#configuration-changes)
- [Module Management](#module-management)
- [Secret Management](#secret-management)
- [Maintenance](#maintenance)
- [Troubleshooting](#troubleshooting)
- [Git Operations](#git-operations)

## System Management

### Rebuild Commands

```bash
# Apply changes and make bootable
sudo nixos-rebuild switch --flake .#Desktop

# Apply changes temporarily (not bootable)
sudo nixos-rebuild test --flake .#Desktop

# Build only (don't apply)
sudo nixos-rebuild build --flake .#Desktop

# Build and set for next boot only
sudo nixos-rebuild boot --flake .#Desktop
```

### Using Aliases

```bash
# Defined in modules/shell/commonAliases.nix

os              # Switch with nh (nh os switch -a)
ou              # Update and switch (update + apply)
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
sudo nix-env --delete-generations 14d --profile /nix/var/nix/profiles/system  # Older than 14 days
```

## Configuration Changes

### Changing Theme

Edit `hosts/{Desktop,Laptop}/modules/userOptions.nix`:

```nix
config.userOptions = {
  colorScheme = "kanagawa";  # Change this
  wallpaper = "kanagawa.png";  # And this (in assets/)
};
```

Available color schemes: https://github.com/tinted-theming/schemes

Popular choices:
- `kanagawa` - Warm, Japanese inspired
- `catppuccin-macchiato` - Pastel, soothing
- `tokyo-night` - Deep, vibrant
- `gruvbox-dark-medium` - Retro groove
- `nord` - Arctic, blue-tinted

### Enabling/Disabling Programs

Edit `hosts/{Desktop,Laptop}/modules/programs.nix`:

```nix
{
  config = {
    programs = {
      gaming.enable = true;        # Enable
      content.enable = false;      # Disable
      dev.enable = true;           # Enable
    };

    # Add optional packages to a module
    programs.dev.optionalPackages = [
      pkgs.jetbrains.idea-ultimate
    ];
  };
}
```

### Adding Packages

#### One-time Install (Temporary)
```bash
nix shell nixpkgs#package-name
```

#### To User Profile
```nix
# In hosts/Desktop/modules/programs.nix
programs.dev.optionalPackages = [
  pkgs.package-name
];
```

#### System-wide
```nix
# In appropriate module
environment.systemPackages = [ pkgs.package-name ];
```

### Changing Wallpaper

1. Add image to `assets/`
2. Update `hosts/{Desktop,Laptop}/modules/userOptions.nix`:
   ```nix
   config.userOptions.wallpaper = "new-wallpaper.png";
   ```
3. Rebuild: `sudo nixos-rebuild switch --flake .#Desktop`

## Module Management

### Enable a Module

```nix
# In hosts/Desktop/modules/programs.nix
programs.feature.enable = true;
```

### Create New Module

```bash
# 1. Create file
mkdir -p modules/applications/myapp
touch modules/applications/myapp/default.nix

# 2. Add import in parent default.nix
# modules/applications/default.nix
imports = [ ./myapp ];

# 3. Write module (see MODULE_GUIDE.md)

# 4. Enable in host config
programs.myapp.enable = true;

# 5. Test
nix flake check
sudo nixos-rebuild test --flake .#Desktop
```

## Secret Management

### List Secrets

```bash
cd secrets
ls *.age
```

### Create New Secret

```bash
cd secrets

# 1. Add to secrets.nix
# "newsecret.age".publicKeys = users;

# 2. Create and edit
agenix -e newsecret.age

# 3. Reference in config
age.secrets.newsecret = {
  file = ../secrets/newsecret.age;
  owner = config.userOptions.username;
};

# 4. Use in configuration
config.age.secrets.newsecret.path
```

### Edit Existing Secret

```bash
cd secrets
agenix -e secretname.age

# Or with explicit key
agenix -e secretname.age -i ~/.ssh/id_ed25519
```

### Rekey All Secrets

After adding/removing keys in `secrets/secrets.nix`:

```bash
cd secrets
agenix --rekey
```

## Maintenance

### Update Flake Inputs

```bash
# Update all inputs
nix flake update

# Update specific input
nix flake update nixpkgs

# Update and rebuild
ou  # alias for update + switch
```

### Garbage Collection

```bash
# Automatic (configured to run daily)
# Removes generations >10 days old

# Manual: Remove old generations
nix-collect-garbage -d

# Manual: Remove and optimize
sudo nix-collect-garbage -d
nix store optimise

# Check space saved
df -h /nix
```

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

# Defragment specific directory
sudo btrfs filesystem defragment -r /home

# Trim SSD
sudo fstrim -av
```

### Monitor Disk Usage

```bash
# Overall usage
df -h

# Nix store size
du -sh /nix/store

# Largest packages
nix path-info -rsSh /run/current-system | sort -hk2 | tail -20

# Disk usage by generation
nix-env --list-generations --profile /nix/var/nix/profiles/system
```

## Troubleshooting

### Build Fails

```bash
# Check flake syntax
nix flake check

# Show more details
nix flake show

# Try with more verbosity
sudo nixos-rebuild switch --flake .#Desktop --show-trace
```

### Service Not Starting

```bash
# Check service status
systemctl status service-name

# View logs
journalctl -u service-name

# View recent logs (follow)
journalctl -u service-name -f

# View boot logs
journalctl -b

# View logs since last boot
journalctl -b -1
```

### Application Not Found

```bash
# Check if installed
which app-name

# Search available packages
nix search nixpkgs app-name

# Check what current system provides
ls -l /run/current-system/sw/bin/
```

### Configuration Errors

```bash
# Rollback immediately
sudo nixos-rebuild switch --rollback

# Boot previous generation
# (Select at boot menu)

# Check what changed
nixos-rebuild switch --flake .#Desktop --dry-run
```

### Hyprland Issues

```bash
# Check if running
ps aux | grep hyprland

# Check logs
journalctl --user -u hyprland

# Restart (from TTY)
sudo systemctl restart display-manager

# Check UWSM status
systemctl --user status uwsm@hyprland-uwsm.desktop.service
```

### Network Issues

```bash
# Check status
systemctl status NetworkManager

# Restart network
sudo systemctl restart NetworkManager

# View network logs
journalctl -u NetworkManager
```

## Git Operations

### Commit Configuration Changes

```bash
# Check status
git status

# View changes
git diff

# Stage all changes
git add .

# Commit with message
git commit -m "feat: add XYZ feature"

# Push to remote
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

### Branches

```bash
# Create new branch
git checkout -b feature/new-feature

# Switch branches
git checkout main

# Merge branch
git merge feature/new-feature

# Delete branch
git branch -d feature/new-feature
```

## Useful Commands Reference

### System Information

```bash
# NixOS version
nixos-version

# Hardware info
lshw -short
lspci
lsusb

# CPU info
lscpu

# Memory info
free -h

# Disk info
lsblk
df -h

# System info (fastfetch)
ff
```

### File Operations

```bash
# List files (eza)
ls          # Basic list
la          # All files with details (eza -lah)
tree        # Tree view

# File search
find . -name "pattern"
fd pattern  # Better find

# Content search
grep -r "pattern" .
rg pattern  # Better grep (ripgrep)
```

### Process Management

```bash
# List processes
ps aux
htop

# Kill process
kill PID
killall process-name

# Check port usage
sudo lsof -i :PORT
sudo netstat -tulpn | grep PORT
```

### Package Information

```bash
# Search for package
nix search nixpkgs package-name

# Show package info
nix eval nixpkgs#package-name.meta.description

# Check package version
nix eval nixpkgs#package-name.version

# Where is package installed
which package-name
```

## Quick Fixes

### "No space left on device"

```bash
# On Btrfs (metadata full)
sudo btrfs balance start -dusage=50 /

# General cleanup
sudo nix-collect-garbage -d
```

### Boot fails after update

1. Select previous generation at boot menu
2. Boot into working system
3. Check what changed: `journalctl -b -1`
4. Fix issue or rollback: `sudo nixos-rebuild switch --rollback`

### Locked Flake

```bash
# If nix flake update fails
rm flake.lock
nix flake update
```

### Hyprland frozen

```bash
# From TTY (Ctrl+Alt+F2)
systemctl --user restart hyprland

# Or restart display manager
sudo systemctl restart display-manager
```

## Configuration Locations

```
~/.dotfiles/                          # This repository
  ├── flake.nix                       # Flake definition
  ├── hosts/Desktop/                  # Desktop configuration
  │   └── modules/
  │       ├── programs.nix            # Enabled programs
  │       └── userOptions.nix         # Theme, wallpaper, etc.
  ├── modules/                        # Feature modules
  ├── system/                         # Core system config
  └── secrets/                        # Encrypted secrets

/etc/nixos/                           # Symlinks to config
/run/current-system/                  # Current system closure
/nix/var/nix/profiles/system          # System profile
/home/$USER/.config/                  # User configs (managed by Home Manager)
```

## Environment Variables

Important environment variables set in this config:

```bash
# In modules/desktop/hypr/hyprland.nix
XDG_CURRENT_DESKTOP=Hyprland
MOZ_ENABLE_WAYLAND=1
QT_QPA_PLATFORM=wayland

# Check current variables
printenv
env | grep VARIABLE
```

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Architecture Documentation](./ARCHITECTURE.md)
- [Module Guide](./MODULE_GUIDE.md)
- [Contributing](../CONTRIBUTING.md)
