# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## System Management Commands

```bash
os          # Apply system changes (alias: nh os switch -a)
ou          # Update flake inputs and apply changes
nix fmt     # Format all Nix files
nix flake check                               # Validate configuration syntax
sudo nixos-rebuild build --flake .#Desktop   # Dry-run build (no switch)
sudo nixos-rebuild test --flake .#Desktop    # Temporary activation (no boot entry)
sudo nixos-rebuild switch --flake .#Desktop  # Apply to running system
sudo nixos-rebuild switch --rollback         # Revert to previous generation
```

Hosts: `Desktop`, `Laptop`

## Architecture

**NixOS Flakes** with **flake-parts** + **import-tree** for automatic module discovery. All `.nix` files in `assets/`, `core/`, `hosts/`, `modules/`, and `users/` are discovered automatically — no manual imports needed when adding files.

### Directory Roles

- `core/` — Always-enabled system configuration (boot, hardware drivers, Nix daemon, base services)
- `modules/` — Opt-in feature modules, each with an `enable` option
- `hosts/` — Per-host configuration; Desktop and Laptop each import and toggle modules
- `users/v3rm1n/` — User account + Home Manager config
- `hosts/common/` — Configuration shared across all hosts

### Module Pattern

Every module in `modules/` follows this structure:

```nix
_: {
  flake.nixosModules.uniqueModuleName =
    { lib, config, pkgs, ... }:
    let
      cfg = config.<namespace>.<feature>;
    in
    {
      options.<namespace>.<feature> = {
        enable = lib.mkEnableOption "description";
        # additional options...
      };

      config = lib.mkIf cfg.enable {
        # configuration goes here
      };
    };
}
```

Module names are derived from file paths (e.g., `modules/applications/gaming/` → `modulesApplicationsGaming`). To enable a module in a host, add it to that host's modules list with `enable = true`.

### User Options

Centralized user options live in `modules/user/`. These expose settings like `username`, `hostname`, `browser`, `colorScheme`, and `wallpaper` that other modules reference via `config.user.*`.

### Theming

All theming is handled by **Stylix** (Catppuccin Macchiato). Don't hardcode colors or fonts — reference Stylix values so the entire system theme changes from one place.

### Secrets

Secrets use **agenix** — encrypted files committed to the repo, decrypted at activation. Never store plaintext secrets.

## Stack

- Display: Wayland / Hyprland + Hyprpanel
- Terminal: Ghostty
- Shell: Zsh + Powerlevel10k
- Editor: Neovim (nix-wrapped), VSCode
- Browser: Helium
- Filesystem: Btrfs (auto-scrub/balance via `core/nix/`)
- Boot: Lanzaboote (Secure Boot)
