# ADR 0003: Stylix for Unified Theming

**Status:** Accepted

**Date:** 2024

## Context

Managing consistent theming across multiple applications (terminal, editor, browser, WM, etc.) is tedious and error-prone. Each application has its own configuration format and color scheme definition. We needed a solution to maintain visual consistency across the entire system.

## Decision

We will use [Stylix](https://github.com/danth/stylix) for unified theming with base16 color schemes.

## Rationale

### What is Stylix?

Stylix is a NixOS module that:
- Takes a base16 color scheme and wallpaper as input
- Automatically themes compatible applications
- Generates consistent colors across the entire system
- Integrates with Home Manager

### Advantages

1. **Single Source of Truth**
   - Define color scheme once in `userOptions`
   - Automatically propagates to all applications
   - No manual color code synchronization

2. **Wide Application Support**
   - Hyprland, kitty, WezTerm, VSCode, Firefox
   - GTK, Qt applications
   - Terminal applications
   - Automatically adds new apps as they're supported

3. **Base16 Ecosystem**
   - Access to [hundreds of color schemes](https://github.com/tinted-theming/schemes)
   - Consistent color definitions across community
   - Can easily switch schemes

4. **Declarative Configuration**
   ```nix
   config.userOptions = {
     colorScheme = "kanagawa";
     wallpaper = "kanagawa.png";
   };
   ```
   That's it! Entire system is themed.

5. **Wallpaper Integration**
   - Can generate color scheme from wallpaper
   - Or use matching wallpaper for color scheme
   - Automatic contrast adjustments

### Compared to Manual Theming

**Without Stylix:**
```nix
# Terminal colors (16 colors)
programs.wezterm.colors = { ... };

# GTK theme
gtk.theme = { ... };

# Hyprland colors (separate format)
wayland.windowManager.hyprland.colors = { ... };

# VSCode theme
programs.vscode.theme = { ... };

# ... and so on for every application
```

**With Stylix:**
```nix
stylix = {
  enable = true;
  base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
  image = ./assets/kanagawa.png;
};
```

## Alternatives Considered

### Manual Per-Application Theming
- **Pros:** Complete control, no dependencies
- **Cons:** Extremely tedious, inconsistencies inevitable, hard to change schemes
- **Rejected:** Not maintainable

### Home Manager Theme Modules
- **Pros:** Native to home-manager, well-supported
- **Cons:** Still requires per-application configuration, no unified scheme
- **Rejected:** Doesn't solve the consistency problem

### Pywal/wpgtk
- **Pros:** Popular, generates from wallpaper, works outside NixOS
- **Cons:** Not declarative, imperative, doesn't integrate with NixOS modules
- **Rejected:** Goes against NixOS philosophy

### Nix-colors
- **Pros:** Similar to Stylix, NixOS-native
- **Cons:** Less comprehensive application support, less active development
- **Rejected:** Stylix has better ecosystem

## Consequences

### Positive
- Changing theme is a single line change
- New applications are automatically themed
- Consistent colors across entire system
- Wallpaper and colors always match
- Can experiment with color schemes easily

### Negative
- Dependency on Stylix project
- Limited control over per-application overrides (though possible)
- Some applications may not be supported yet
- Generated themes may not be perfect for all apps

### Neutral
- Tied to base16 color scheme format
- Need to add wallpapers to `assets/` directory

## Implementation

### Module Setup
```nix
# modules/desktop/stylix/default.nix
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.userOptions.colorScheme}.yaml";
    image = ../../assets/${config.userOptions.wallpaper};

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      # ... other font configurations
    };
  };
}
```

### User Configuration
```nix
# hosts/Desktop/modules/userOptions.nix
config.userOptions = {
  colorScheme = "kanagawa";
  wallpaper = "kanagawa.png";
};
```

### Per-Application Overrides
If needed, can still override specific applications:
```nix
stylix.targets.hyprland.enable = false;
# Then configure Hyprland colors manually
```

## Supported Applications

Currently themed (non-exhaustive):
- **Terminals:** WezTerm, Kitty, Alacritty
- **Editors:** Neovim, VSCode, Helix
- **WM/DE:** Hyprland, Sway, i3
- **Shells:** Bash, Zsh, Fish
- **Applications:** Firefox, Rofi, Dunst
- **Toolkits:** GTK 2/3/4, Qt5/6

See [Stylix documentation](https://stylix.danth.me/options/nixos.html) for full list.

## Customization Options

### Available Schemes
Browse at [Tinted Theming](https://github.com/tinted-theming/schemes):
- `kanagawa` - Warm, inspired by Japanese paintings
- `catppuccin-macchiato` - Pastel, soothing
- `tokyo-night` - Deep, vibrant
- `nord` - Arctic, blue-tinted
- `gruvbox-dark-medium` - Retro groove
- Hundreds more...

### Font Configuration
Stylix also manages fonts:
- Serif, Sans Serif, Monospace
- Sizes for different UI elements
- Per-application font overrides

### Wallpaper Modes
```nix
stylix.image = ./wallpaper.png;  # Use specific wallpaper

# Or generate colors from wallpaper
stylix.autoEnable = true;  # Auto-generate from image
```

## Review

This decision should be reviewed if:
- Stylix project becomes unmaintained
- Better theming solutions emerge
- We need more control over individual app themes
- Base16 becomes limiting for our needs

## References

- [Stylix GitHub](https://github.com/danth/stylix)
- [Stylix Documentation](https://stylix.danth.me/)
- [Base16 Schemes Gallery](https://tinted-theming.github.io/base16-gallery/)
