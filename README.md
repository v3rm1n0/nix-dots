<div align="center">

# v3rm1n's NixOS Dotfiles

_Declarative NixOS configuration with Flakes & Home Manager_

[![Stars](https://img.shields.io/github/stars/v3rm1n0/nix-dots?color=F5BDE6&labelColor=303446&style=for-the-badge&logo=starship&logoColor=F5BDE6)](https://github.com/v3rm1n0/nix-dots/stargazers)
[![Repo Size](https://img.shields.io/github/repo-size/v3rm1n0/nix-dots?color=C6A0F6&labelColor=303446&style=for-the-badge&logo=github&logoColor=C6A0F6)](https://github.com/v3rm1n0/nix-dots/)
[![NixOS](https://img.shields.io/badge/NixOS-Unstable-blue?style=for-the-badge&logo=NixOS&logoColor=white&label=NixOS&labelColor=303446&color=91D7E3)](https://nixos.org)
[![License](https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&colorA=313244&colorB=F5A97F&logo=unlicense&logoColor=F5A97F&)](https://github.com/v3rm1n0/nix-dots/blob/main/LICENSE)

<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="600px" alt="Catppuccin Macchiato Palette" />

</div>

## Project Overview

<details>
    <summary> Flake Setup </summary>

This document provides an overview of my NixOS flake configuration, including the folder structure, system management commands, and shell shortcuts.

## Flake Structure

My NixOS configuration is organized into a modular flake to ensure a clean and reproducible setup across multiple machines.

- `hosts/`: Contains host-specific configurations.
  - `Desktop/`: Configuration for the desktop machine and their respective modules.
  - `Laptop/`: Configuration for the laptop machine and their respective modules.
  - `common/`: Shared settings for all hosts, such as locale and environment variables.
- `modules/`: Contains the main modular configuration files, broken down by category.
  - `applications/`: Module configurations for various applications like browsers, communication tools, and productivity software.
  - `desktop/`: Module configuration for the desktop environment (Hyprland), display managers, and styling.
  - `hardware/`: Hardware-module-specific configurations for peripherals.
  - `security/`: Security-related settings for authentication, encryption, and GnuPG.
  - `services/`: Module configurations for non-system services.
  - `shell/`: Configurations for the shell, including Zsh and Bash, and their aliases.
  - `user/`: User-specific modules, such as wallpaper, hostname and username options.
- `secrets/`: This directory is used to handle secrets via `agenix`. It contains encrypted files (`.age`) and a `secrets.nix` file that lists public keys for decryption.
- `system/`: Contains configuration modules essential for every running NixOS instance.
- `users/`: Holds user-specific configurations, such as the `v3rm1n` user settings.
- `default.nix`: This file imports the main modules and defines the overall structure.
- `flake.nix`: This is the entry point of the configuration. It defines the flake inputs (`nixpkgs`, `home-manager`, `stylix`, etc.) and the NixOS configurations for `Desktop` and `Laptop`.

## System Management

The following commands are used for managing the NixOS system, as defined in `README.md` and `modules/shell/commonAliases.nix`.

- `nixos-rebuild switch --flake .#Desktop`: Applies system changes.
- `nh os switch -a` (alias `os`): Applies system changes.
- `nh os switch -a -u` (alias `ou`): Applies system changes and updates all flake inputs.
- `nix flake update`: Updates all flake inputs manually.
- `nix flake check`: Validates the flake configuration.

## Shell Shortcuts (Aliases)

The `commonAliases.nix` file defines a set of useful shell aliases for both Bash and Zsh.

- `la`: `eza -lah` (lists files with details, showing hidden files).
- `ls`: `eza` (lists files).
- `tree`: `eza --tree --git-ignore` (lists files in a tree format, ignoring git files).
- `vi` and `vim`: `nvim` (opens Neovim).
- `ff`: `fastfetch` (runs the fastfetch system information tool).
- `ga`: `git add .` (stages all changes).
- `gc`: `git commit -m` (commits changes with a message).
- `gcfu`: `git commit -m 'Updated Flake'` (commits changes with a standard message).
- `cat`: `bat` (a `cat` alternative with syntax highlighting).
- `man`: `batman` (a `man` alternative).
</details>

## System Information

- **OS**: NixOS (Unstable channel)
- **Desktop**: Hyprland with UWSM
- **Filesystem**: Btrfs
- **Package Manager**: Nix with Flakes
- **Configuration**: Fully declarative and reproducible

## Installation Instructions

<details>
    <summary>Show Instructions</summary>
    
  ```bash
  # Clone the repository
  git clone https://github.com/v3rm1n0/nix-dots.git
  cd nix-dots

# Partition and format disk with Disko

sudo nix --experimental-features "nix-command flakes" run \
 github:nix-community/disko/latest -- \
 --mode destroy,format,mount ./disko-defaults.nix

# Only for low ram devices!

sudo mkdir /mnt/swap
sudo chattr +C /mnt/swap
sudo dd if=/dev/zero of=/mnt/swap/swapfile bs=1M count=8048 status=progress
sudo chmod 600 /mnt/swap/swapfile
sudo mkswap /mnt/swap/swapfile
sudo swapon /mnt/swap/swapfile

# Install NixOS

sudo nixos-install --flake .#Desktop

````

### Existing System

```bash
# Clone the repository
git clone https://github.com/v3rm1n0/nix-dots.git
cd nix-dots

# Apply configuration
sudo nixos-rebuild switch --flake .#Desktop
````

</details>

## System Management

| Command                                       | Description                          |
| --------------------------------------------- | ------------------------------------ |
| `sudo nixos-rebuild switch --flake .#Desktop` | Apply system changes                 |
| `nixos-rebuild test --flake .#Desktop`        | Test configuration without switching |
| `nix flake update`                            | Update all flake inputs              |
| `nix flake check`                             | Validate flake configuration         |

<div align="center">

_Built with ❤️ and lots of ☕_

**[⭐ Star this repo](https://github.com/v3rm1n0/nix-dots) if you found it helpful!**

Special thanks to [@c0d3h01](https://github.com/c0d3h01) for the inspiration, initial setup and allowing me to copy this gorgeous README file!

</div>
