# ADR 0003: Stylix for Unified Theming

**Status:** Accepted

**Date:** 2024

## Context

Managing consistent theming across multiple applications (terminal, editor, browser, WM, etc.) is tedious and error-prone. Each application has its own configuration format and color scheme definition. We needed a solution to maintain visual consistency across the entire system.

## Decision

We will use [Stylix](https://github.com/nix-community/stylix) for unified theming with base16 color schemes.

## Rationale

### What is Stylix?

Stylix is a NixOS module that:
- Takes a base16 color scheme and wallpaper as input
- Automatically themes compatible applications
- Generates consistent colors across the entire system
- Integrates with both NixOS and Home Manager

### Advantages

1. **Single Source of Truth**
   - Define color scheme once in `userOptions`
   - Automatically propagates to all applications
   - No manual color code synchronization

2. **Wide Application Support**
   - Window managers (Hyprland, Sway), terminals, editors, browsers
   - GTK and Qt applications
   - Shell prompts and system UI

3. **Base16 Ecosystem**
   - Access to hundreds of color schemes
   - Consistent color definitions across community
   - Easy to switch schemes

4. **Declarative Configuration**
   ```nix
   config.userOptions = {
     colorScheme = "your-chosen-scheme";
     wallpaper = "matching-wallpaper.png";
   };
   ```
   That's it — the entire system is themed.

### Compared to Manual Theming

**Without Stylix:**
```nix
programs.ghostty.themes = { ... };      # Terminal colors
gtk.theme = { ... };                    # GTK theme
wayland.windowManager.hyprland.colors = { ... };  # Hyprland colors
programs.vscode.theme = { ... };        # VSCode theme
# ... repeated for every application
```

**With Stylix:**
```nix
stylix = {
  enable = true;
  base16Scheme = "${pkgs.base16-schemes}/share/themes/your-scheme.yaml";
  image = ./assets/wallpapers/your-wallpaper.png;
};
```

## Alternatives Considered

### Manual Per-Application Theming
- **Pros:** Complete control, no dependencies
- **Cons:** Extremely tedious, inconsistencies inevitable, hard to change schemes
- **Rejected:** Not maintainable

### Pywal/wpgtk
- **Pros:** Popular, generates from wallpaper
- **Cons:** Not declarative, imperative, doesn't integrate with NixOS modules
- **Rejected:** Goes against NixOS philosophy

### nix-colors
- **Pros:** Similar to Stylix, NixOS-native
- **Cons:** Less comprehensive application support, less active development
- **Rejected:** Stylix has better ecosystem

## Consequences

### Positive
- Changing theme is a single line change
- New applications are automatically themed
- Consistent colors across entire system
- Wallpaper and colors always match

### Negative
- Dependency on Stylix project
- Limited per-application overrides (though possible via `stylix.targets.<app>.enable = false`)
- Some applications may not be supported
- Generated themes may not be perfect for all apps

### Neutral
- Tied to base16 color scheme format
- Wallpapers must be placed in `assets/wallpapers/`

## Implementation

### Module Setup

```nix
# modules/desktop/stylix/default.nix
{ inputs, ... }: {
  flake.nixosModules.modulesDesktopStylix =
    { config, pkgs, ... }:
    let
      inherit (config.userOptions) colorScheme username;
    in
    {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/${colorScheme}.yaml";
        polarity = "dark";

        cursor = {
          package = pkgs.some-cursor-theme;
          name = "CursorThemeName";
          size = 24;
        };

        fonts = {
          monospace = {
            package = pkgs.some-font;
            name = "Font Name";
          };
          # ... other font slots
        };

        targets.limine.image.enable = false;
      };

      home-manager.users.${username} = {
        stylix = {
          icons = {
            enable = true;
            package = pkgs.some-icon-theme;
            dark = "IconThemeName";
          };
          polarity = "dark";
        };
      };
    };
}
```

### User Configuration

```nix
# hosts/{host}/modules/userOptions.nix
config.userOptions = {
  colorScheme = "your-scheme-name";
  wallpaper = "your-wallpaper.png";
};
```

### Per-Application Overrides

```nix
stylix.targets.hyprland.enable = false;
# Then configure Hyprland colors manually
```

## Supported Applications

Currently themed (non-exhaustive):
- **Terminals:** Ghostty, Kitty, Alacritty
- **Editors:** Neovim, VSCode, Helix
- **WM/DE:** Hyprland, Sway
- **Shells:** Bash, Zsh, Fish
- **Applications:** Firefox, Rofi, Dunst
- **Toolkits:** GTK 2/3/4, Qt5/6

See [Stylix documentation](https://stylix.danth.me/options/nixos.html) for the full list.

## Customization Options

### Available Schemes
Browse schemes at the [Tinted Theming Gallery](https://tinted-theming.github.io/base16-gallery/).

### Font Configuration
Stylix manages fonts across the system:
- Serif, Sans Serif, Monospace, Emoji
- Sizes for applications, desktop, popups, terminal

## Review

This decision should be reviewed if:
- Stylix project becomes unmaintained
- Better theming solutions emerge
- We need more control over individual app themes
- Base16 becomes limiting

## References

- [Stylix GitHub](https://github.com/nix-community/stylix)
- [Stylix Documentation](https://stylix.danth.me/)
- [Base16 Schemes Gallery](https://tinted-theming.github.io/base16-gallery/)
