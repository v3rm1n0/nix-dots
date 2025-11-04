# Stylix Configuration Module
#
# This module configures Stylix for unified system-wide theming based on base16 color schemes.
# Stylix automatically themes compatible applications including terminals, editors, browsers,
# window managers, and more.
#
# Color scheme is set via `config.userOptions.colorScheme` in host configuration.
# See: docs/adr/0003-stylix-for-theming.md for architecture decision details.
#
# Theming coverage:
#   - Window Manager: Hyprland, Sway, etc.
#   - Terminals: Ghostty, Kitty, Alacritty
#   - Editors: Neovim, VSCode, Helix
#   - Shell: Bash, Zsh, Fish
#   - GTK/Qt applications
#   - System UI elements (cursor, icons, fonts)

{
  config,
  pkgs,
  ...
}:
let
  colorScheme = config.userOptions.colorScheme;
  username = config.userOptions.username;
in
{
  # System-level Stylix configuration
  stylix = {
    enable = true;

    # Base16 color scheme from the tinted-theming/schemes repository
    # Available schemes: https://github.com/tinted-theming/schemes
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${colorScheme}.yaml";

    # Cursor theme configuration
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 25;
    };

    # Font configuration for the entire system
    # Stylix will apply these fonts to all compatible applications
    fonts = {
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      monospace = {
        package = pkgs.nerd-fonts.geist-mono;
        name = "Geist Mono";
      };
      sansSerif = {
        package = pkgs.geist-font;
        name = "Geist";
      };
      # Use same font for serif as sans-serif for consistency
      serif = config.stylix.fonts.sansSerif;

      # Font sizes for different UI elements
      sizes = {
        applications = 12; # General application text
        desktop = 10; # Desktop environment elements
        popups = 10; # Notification popups
        terminal = 10; # Terminal emulator text
      };
    };

    # Color polarity (dark mode)
    polarity = "dark";
  };

  # User-level Stylix configuration (via Home Manager)
  home-manager.users.${username} = {
    stylix = {
      # Icon theme configuration
      icons = {
        enable = true;
        package = pkgs.kora-icon-theme;
        dark = "kora";
      };

      # Application transparency (0.0 = fully transparent, 1.0 = opaque)
      # Applied to compatible applications like terminals
      opacity.applications = 0.8;

      # Ensure user-level theme matches system polarity
      polarity = "dark";
    };
  };
}
