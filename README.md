<div align="center">

# v3rm1n's NixOS Dotfiles

_Declarative NixOS configuration with Flakes & Home Manager_

[![Stars](https://img.shields.io/github/stars/v3rm1n0/nix-dots?color=F5BDE6&labelColor=303446&style=for-the-badge&logo=starship&logoColor=F5BDE6)](https://github.com/v3rm1n0/nix-dots/stargazers)
[![Repo Size](https://img.shields.io/github/repo-size/v3rm1n0/nix-dots?color=C6A0F6&labelColor=303446&style=for-the-badge&logo=github&logoColor=C6A0F6)](https://github.com/v3rm1n0/nix-dots/)
[![NixOS](https://img.shields.io/badge/NixOS-Unstable-blue?style=for-the-badge&logo=NixOS&logoColor=white&label=NixOS&labelColor=303446&color=91D7E3)](https://nixos.org)
[![License](https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&colorA=313244&colorB=F5A97F&logo=unlicense&logoColor=F5A97F&)](https://github.com/v3rm1n0/nix-dots/blob/main/LICENSE)

<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="600px" alt="Catppuccin Macchiato Palette" />

</div>

---

## System Information

- **OS**: NixOS (Unstable channel)
- **Desktop**: Hyprland with UWSM
- **Filesystem**: Btrfs
- **Package Manager**: Nix with Flakes
- **Configuration**: Fully declarative and reproducible

### Fresh Installation

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
```

### Existing System

```bash
# Clone the repository
git clone https://github.com/v3rm1n0/nix-dots.git
cd nix-dots

# Apply configuration
sudo nixos-rebuild switch --flake .#Desktop
```

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
