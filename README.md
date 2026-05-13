<div align="center">

# v3rm1n's NixOS Dotfiles

_Declarative NixOS configuration with Flakes_

[![NixOS](https://img.shields.io/badge/NixOS-Unstable-blue?style=for-the-badge&logo=NixOS&logoColor=white&label=NixOS&labelColor=303446&color=91D7E3)](https://nixos.org)
[![License](https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=WTFPL&colorA=313244&colorB=F5A97F&logo=unlicense&logoColor=F5A97F&)](LICENSE)

</div>

## 📚 Overview

A modular NixOS configuration featuring Hyprland, hjem, and comprehensive system management. Built for maintainability and ease of deployment across multiple machines.

### ✨ Key Features

- 🎨 **Unified Theming** with Stylix
- 🔒 **Secure Boot** via Limine
- 🪟 **Hyprland** window manager
- 🏠 **hjem** for declarative user file management
- 📦 **Modular Architecture** with flake-parts + import-tree
- 🗄️ **Btrfs** with automatic maintenance
- ⚡ **Optimized** for both desktop and laptop configurations

## 💻 System Information

### Software Stack

| Component          | Implementation                        |
| ------------------ | ------------------------------------- |
| **OS**             | NixOS Unstable                        |
| **Display Server** | Wayland                               |
| **Window Manager** | Hyprland                              |
| **Panel**          | noctalia-shell                        |
| **Terminal**       | Ghostty                               |
| **Shell**          | Zsh with Powerlevel10k                |
| **Editor**         | Neovim + VSCode                       |
| **Browser**        | Librewolf (Desktop) / Helium (Laptop) |
| **File Manager**   | Nautilus                              |
| **Theme**          | Stylix (gruvbox-dark-hard)            |
| **Filesystem**     | Btrfs with auto-scrub                 |

## 🛠️ System Management

### Common Commands

| Command                                    | Description                                        |
| ------------------------------------------ | -------------------------------------------------- |
| `os`                                       | Apply system changes (alias for `nh os switch -a`) |
| `ou`                                       | Update flake inputs and apply changes              |
| `nix fmt`                                  | Format all Nix files                               |
| `nix flake check`                          | Validate flake configuration                       |
| `sudo nixos-rebuild test --flake .#<host>` | Test configuration without switching               |
| `sudo nixos-rebuild boot --flake .#<host>` | Build and set for next boot                        |

## 📜 License

WTFPL — Do What the Fuck You Want to Public License.

<div align="center">

_Built with ❤️ and lots of ☕_

</div>
