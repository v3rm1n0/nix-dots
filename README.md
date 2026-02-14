<div align="center">

# v3rm1n's NixOS Dotfiles

_Declarative NixOS configuration with Flakes & Home Manager_

[![Stars](https://img.shields.io/gitea/stars/v3rm1n/nix-dots?gitea_url=https%3A%2F%2Fcodeberg.org&color=F5BDE6&labelColor=303446&style=for-the-badge&logo=starship&logoColor=F5BDE6)](https://codeberg.org/v3rm1n/nix-dots/stars)
[![NixOS](https://img.shields.io/badge/NixOS-Unstable-blue?style=for-the-badge&logo=NixOS&logoColor=white&label=NixOS&labelColor=303446&color=91D7E3)](https://nixos.org)
[![License](https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&colorA=313244&colorB=F5A97F&logo=unlicense&logoColor=F5A97F&)](https://codeberg.org/v3rm1n/nix-dots/src/branch/main/LICENSE)

<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="600px" alt="Catppuccin Macchiato Palette" />

</div>

## 📚 Overview

A production-ready, modular NixOS configuration featuring Hyprland, Home Manager, and comprehensive system management. Built for maintainability, security, and ease of deployment across multiple machines.

### ✨ Key Features

- 🎨 **Unified Theming** with Stylix
- 🔒 **Secure Boot** via Lanzaboote
- 🔐 **Secret Management** with agenix
- 🪟 **Hyprland** with UWSM session management
- 🏠 **Home Manager** for declarative user environments
- 📦 **Modular Architecture** for easy customization
- 🗄️ **Btrfs** with automatic maintenance
- ⚡ **Optimized** for both desktop and laptop configurations

## 💻 System Information

### Software Stack

| Component          | Implementation                       |
| ------------------ | ------------------------------------ |
| **OS**             | NixOS Unstable                       |
| **Display Server** | Wayland                              |
| **Window Manager** | Hyprland with UWSM                   |
| **Panel**          | Hyprpanel                            |
| **Terminal**       | Ghostty                              |
| **Shell**          | Zsh with Powerlevel10k               |
| **Editor**         | Neovim + VSCode                      |
| **Browser**        | Helium |
| **File Manager**   | Nautilus                             |
| **Theme**          | Stylix                               |
| **Filesystem**     | Btrfs with auto-scrub                |

## 🚀 Installation

### Prerequisites

- A system with UEFI boot support
- Internet connection
- Basic understanding of NixOS

### New Installation

<details>
<summary><b>Fresh Install Steps</b></summary>

1. **Boot from NixOS installation media**

2. **Clone the repository**

   ```bash
   git clone https://github.com/v3rm1n0/nix-dots.git
   cd nix-dots
   ```

3. **Partition and format disk with Disko**

   ```bash
   sudo nix --experimental-features "nix-command flakes" run \
     github:nix-community/disko/latest -- \
     --mode destroy,format,mount ./disko-defaults.nix
   ```

4. **Optional: Set up swap for low-RAM devices**

   ```bash
   sudo mkdir /mnt/swap
   sudo chattr +C /mnt/swap
   sudo dd if=/dev/zero of=/mnt/swap/swapfile bs=1M count=8048 status=progress
   sudo chmod 600 /mnt/swap/swapfile
   sudo mkswap /mnt/swap/swapfile
   sudo swapon /mnt/swap/swapfile
   ```

5. **Install NixOS**

   ```bash
   sudo nixos-install --flake .#Desktop  # or .#Laptop
   ```

6. **Reboot and enjoy!**

</details>

### Existing System

<details>
<summary><b>Migrate Existing Installation</b></summary>

1. **Clone the repository**

   ```bash
   git clone https://github.com/v3rm1n0/nix-dots.git
   cd nix-dots
   ```

2. **Review and customize**

   - Check `hosts/` for host-specific settings
   - Modify `userOptions` in your host's `userOptions.nix`
   - Adjust hardware configuration

3. **Apply configuration**
   ```bash
   sudo nixos-rebuild switch --flake .#Desktop  # or .#Laptop
   ```

</details>

## 🛠️ System Management

### Common Commands

| Command                                    | Description                                        |
| ------------------------------------------ | -------------------------------------------------- |
| `os`                                       | Apply system changes (alias for `nh os switch -a`) |
| `ou`                                       | Update flake inputs and apply changes              |
| `nix flake update`                         | Update all flake inputs manually                   |
| `nix flake check`                          | Validate flake configuration                       |
| `sudo nixos-rebuild test --flake .#<host>` | Test configuration without switching               |
| `nixos-rebuild boot --flake .#<host>`      | Build and set for next boot                        |


## 🤝 Contributing

While this is a personal configuration, suggestions and improvements are welcome!

- Open an issue for bugs or questions
- Submit PRs for improvements
- Share your own configs inspired by this setup

## 📜 License

MIT License - feel free to use and modify as you wish.

## 📚 Learning Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Stylix Documentation](https://stylix.danth.me/)

<div align="center">

_Built with ❤️ and lots of ☕_

**[⭐ Star this repo](https://codeberg.org/v3rm1n/nix-dots) if you found it helpful!**

</div>
