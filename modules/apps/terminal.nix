_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (config.userOptions) username;
      inherit (config.lib.stylix) colors;
    in
    {
      options.mods.apps.terminal.enable = lib.mkEnableOption "Enable terminal module";

      config = lib.mkIf config.mods.apps.terminal.enable {
        hjem.users.${username}.rum.programs.ghostty = {
          enable = true;
          settings = {
            background-opacity = "0.5";
            cursor-style = "block";
            cursor-style-blink = false;
            shell-integration = "detect";
            font-size = 10;
            background = "#${colors.base00}";
            foreground = "#${colors.base05}";
            cursor-color = "#${colors.base05}";
            selection-background = "#${colors.base02}";
            selection-foreground = "#${colors.base05}";
            palette = [
              "0=#${colors.base00}"
              "1=#${colors.base08}"
              "2=#${colors.base0B}"
              "3=#${colors.base0A}"
              "4=#${colors.base0D}"
              "5=#${colors.base0E}"
              "6=#${colors.base0C}"
              "7=#${colors.base05}"
              "8=#${colors.base03}"
              "9=#${colors.base08}"
              "10=#${colors.base0B}"
              "11=#${colors.base0A}"
              "12=#${colors.base0D}"
              "13=#${colors.base0E}"
              "14=#${colors.base0C}"
              "15=#${colors.base07}"
            ];
          };
        };
      };
    };
}
