<div align="center">

# v3rm1n's NixOS Dotfiles

_Declarative NixOS configuration with Flakes & Home Manager_

[![Stars](https://img.shields.io/github/stars/v3rm1n0/nix-dots?color=F5BDE6&labelColor=303446&style=for-the-badge&logo=starship&logoColor=F5BDE6)](https://github.com/v3rm1n0/nix-dots/stargazers)
[![Repo Size](https://img.shields.io/github/repo-size/v3rm1n0/nix-dots?color=C6A0F6&labelColor=303446&style=for-the-badge&logo=github&logoColor=C6A0F6)](https://github.com/v3rm1n0/nix-dots/)
[![NixOS](https://img.shields.io/badge/NixOS-Unstable-blue?style=for-the-badge&logo=NixOS&logoColor=white&label=NixOS&labelColor=303446&color=91D7E3)](https://nixos.org)
[![License](https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&colorA=313244&colorB=F5A97F&logo=unlicense&logoColor=F5A97F&)](https://github.com/v3rm1n0/nix-dots/blob/main/LICENSE)

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

## 📁 Repository Structure

<details>
<summary><b>Project Layout</b></summary>

```
.
├── flake.nix              # Flake entry point & host definitions
├── default.nix            # Main module imports
├── hosts/                 # Host-specific configurations
│   ├── Desktop/           # Desktop machine config
│   ├── Laptop/            # Laptop machine config
│   └── common/            # Shared host settings (locale, environment)
├── modules/               # Feature modules
│   ├── applications/      # Application configs (browsers, gaming, dev tools)
│   ├── desktop/           # Desktop environment (Hyprland, styling, XDG)
│   ├── hardware/          # Hardware-specific settings (GPU, peripherals)
│   ├── security/          # Security configs (GPG, passwords, agenix)
│   ├── services/          # System services (bluetooth, flatpak, vicinae)
│   ├── shell/             # Shell configuration (zsh, bash, aliases)
│   └── user/              # User-specific options
├── system/                # Core system configuration
│   ├── boot/              # Boot configuration (kernel, plymouth, secure boot)
│   ├── hardware/          # Hardware management (bluetooth, graphics, audio)
│   ├── nix/               # Nix settings, garbage collection, Btrfs maintenance
│   ├── programs/          # System utilities (monitoring, tools)
│   └── services/          # System services (SSH, power management)
├── users/                 # User account definitions
├── secrets/               # Encrypted secrets (agenix)
└── assets/                # Wallpapers and static resources
```

</details>

## 🏗️ Architecture

### Module System

The configuration uses a **highly modular approach** with clear separation of concerns:

- **Host-specific settings**: `hosts/{Desktop,Laptop}/`
- **Feature modules**: `modules/` with enable options
- **System essentials**: `system/` for core functionality
- **User configurations**: Home Manager in `users/`

### Configuration Options

Most modules expose simple enable options:

```nix
# Example host configuration
config = {
  programs.gaming.enable = true;
  programs.dev.enable = true;
  servicesModule.tailscale.enable = true;

  # Hardware configuration
  hardwareModule.gpu = {
    enable = true;
    brand = "nvidia";  # or "intel", "amd"
  };
};
```

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

### Hardware Support

#### Desktop Configuration

- **GPU**: NVIDIA (proprietary drivers)
- **Peripherals**: Razer devices (OpenRazer)
- **Monitors**: Dual monitor setup (180Hz + 60Hz)

#### Laptop Configuration

- **GPU**: Intel integrated graphics
- **Power Management**: power-profiles-daemon, hypridle
- **Display**: 180Hz internal display with external monitor support

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

### Maintenance

#### Garbage Collection

Automatic garbage collection runs daily:

- Removes generations older than 10 days
- Optimizes Nix store automatically

Manual cleanup:

```bash
nix-collect-garbage -d  # Delete all old generations
sudo nix-collect-garbage -d  # Also clean system profile
```

#### Btrfs Maintenance

Automated weekly tasks:

- **Scrub**: Data integrity verification
- **Balance**: Space optimization (when on AC power)
- **Trim**: SSD optimization

Manual operations:

```bash
sudo btrfs scrub start /
sudo btrfs balance start -dusage=75 /
sudo fstrim -av
```

### Shell Shortcuts

The following aliases are available in both Bash and Zsh:

```bash
# File navigation
la        # List all files with details (eza -lah)
tree      # Tree view, respecting .gitignore

# Editor
vi, vim   # Open Neovim

# System info
ff        # Display system information (fastfetch)

# Git shortcuts
ga        # Git add all (git add .)
gc        # Git commit with message
gcfu      # Git commit with "Updated Flake"

# Better alternatives
cat       # bat (syntax highlighting)
man       # batman (bat manual pages)
```

## 🔐 Secret Management

Secrets are managed using [agenix](https://github.com/ryantm/agenix) for secure, encrypted configuration.

### Setup

1. **Generate an SSH key for agenix**

   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/agenix_key
   ```

2. **Add your public key to `secrets/secrets.nix`**

   ```nix
   let
     yourkey = "ssh-ed25519 AAAA... user@host";
     users = [ yourkey ];
   in
   {
     "secretfile.age".publicKeys = users;
   }
   ```

3. **Create and edit secrets**

   ```bash
   cd secrets
   agenix -e secretfile.age
   ```

4. **Reference in configuration**
   ```nix
   age.secrets.secretfile = {
     file = ../secrets/secretfile.age;
     owner = "username";
   };
   ```

See `secrets/readme.md` for detailed instructions.

## 🎨 Customization

### Changing Themes

Edit your host's `userOptions.nix`:

```nix
config.userOptions = {
  colorScheme = "kanagawa";  # Any base16 scheme name
  wallpaper = "kanagawa.png";  # File in assets/
};
```

Available color schemes: [base16-schemes](https://github.com/tinted-theming/schemes)

### Adding Applications

1. Enable built-in modules:

   ```nix
   config.programs = {
     gaming.enable = true;
     content.enable = true;  # OBS, DaVinci Resolve
   };
   ```

2. Add optional packages:
   ```nix
   config.programs.dev.optionalPackages = [
     pkgs.jetbrains.idea-ultimate
   ];
   ```

### Creating New Hosts

1. Copy an existing host directory:

   ```bash
   cp -r hosts/Desktop hosts/NewHost
   ```

2. Update `flake.nix`:

   ```nix
   NewHost = inputs.nixpkgs.lib.nixosSystem {
     specialArgs = { inherit system; } // inputs;
     modules = [ ./. ./hosts/NewHost ];
   };
   ```

3. Customize hardware and settings in `hosts/NewHost/`

## 🐛 Troubleshooting

### Common Issues

<details>
<summary><b>Secure Boot Issues</b></summary>

If system won't boot after enabling secure boot:

1. Boot into BIOS/UEFI
2. Disable secure boot temporarily
3. Boot into system and check:
   ```bash
   sudo sbctl status
   sudo sbctl verify
   ```
4. If needed, re-enroll keys:
   ```bash
   sudo sbctl enroll-keys --microsoft
   ```

</details>

<details>
<summary><b>GPU Driver Issues</b></summary>

**NVIDIA:**

- Check `hardwareModule.gpu.brand = "nvidia"` is set
- Verify in `nix-store` that nvidia driver is present
- Check kernel logs: `journalctl -b | grep -i nvidia`

**Intel:**

- Ensure `hardware.graphics.extraPackages` includes Intel media drivers
- For older GPUs, uncomment `intel-media-sdk` in `system/hardware/graphics/default.nix`

</details>

<details>
<summary><b>Hyprland Not Starting</b></summary>

1. Check UWSM status:

   ```bash
   systemctl --user status uwsm@hyprland-uwsm.desktop.service
   ```

2. View logs:

   ```bash
   journalctl --user -u uwsm@hyprland-uwsm.desktop.service
   ```

3. Try manual start:
   ```bash
   uwsm start hyprland-uwsm.desktop
   ```

</details>

### Known Limitations

- **Webcam configuration** requires the UGREEN 2K Webcam (or modify `system/hardware/webcam/default.nix`)
- **Razer peripherals** require OpenRazer kernel module (Desktop only)
- **Some electron apps** may need manual Wayland flags

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

**[⭐ Star this repo](https://github.com/v3rm1n0/nix-dots) if you found it helpful!**

Special thanks to [@c0d3h01](https://github.com/c0d3h01) for the inspiration, initial setup and allowing me to copy this gorgeous README file!

</div>
