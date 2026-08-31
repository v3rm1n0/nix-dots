{
  flake.modules.nixos.default =
    { lib, ... }:
    {
      options.userOptions = {
        colorScheme = lib.mkOption {
          type = lib.types.str;
          description = ''
            The base16 color scheme name for Stylix theming.
            This is a single system-wide value (GRUB/console/GTK/cursor theme
            all come from one Stylix instance), shared by every user on the host.

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
      };
    };
}
