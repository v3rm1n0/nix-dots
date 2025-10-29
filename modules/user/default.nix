# User Options Module
#
# This module defines the core user-level configuration options that are used
# throughout the system. These options provide a centralized way to configure
# user-specific settings without modifying individual modules.
#
# Usage:
#   Set these options in your host configuration (e.g., hosts/Desktop/modules/userOptions.nix):
#
#   config.userOptions = {
#     username = "myuser";
#     hostName = "myhost";
#     browser = "firefox";
#     colorScheme = "kanagawa";
#     wallpaper = "kanagawa.png";
#     dots = "/home/myuser/.dotfiles";
#   };
#
# These options are then accessible throughout all modules via `config.userOptions.*`

{ lib, ... }:

{
  options.userOptions = {
    browser = lib.mkOption {
      type = lib.types.str;
      description = ''
        The browser CLI command to use as the default browser.
        This should match the executable name of a browser enabled in the browsing module.

        Examples: "firefox", "chromium", "librewolf"
      '';
    };

    colorScheme = lib.mkOption {
      type = lib.types.str;
      description = ''
        The base16 color scheme name for Stylix theming.
        This will be used to theme all compatible applications system-wide.

        Available schemes: https://github.com/tinted-theming/schemes
        Popular options: "kanagawa", "catppuccin-macchiato", "tokyo-night", "gruvbox-dark-medium", "nord"
      '';
      example = "kanagawa";
    };

    dots = lib.mkOption {
      type = lib.types.str;
      description = ''
        The absolute path to the dotfiles repository (flake root).
        Used by various modules to reference assets and configuration files.
      '';
      example = "/home/user/.dotfiles";
    };

    hostName = lib.mkOption {
      type = lib.types.str;
      description = ''
        The hostname for this system.
        This will be set as the system hostname and can be used for host-specific configuration.
      '';
      example = "Desktop";
    };

    username = lib.mkOption {
      type = lib.types.str;
      description = ''
        The primary user's username for this system.
        This is used throughout the configuration for Home Manager and user-specific settings.
      '';
      example = "myuser";
    };

    wallpaper = lib.mkOption {
      type = lib.types.str;
      description = ''
        The wallpaper filename (without path).
        The file should be located in the assets/ directory of this repository.
        Stylix will use this wallpaper and can optionally generate colors from it.
      '';
      example = "kanagawa.png";
    };
  };
}
