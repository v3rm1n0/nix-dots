_: {
  flake.nixosModules.applicationsTerminal =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
      inherit (config.lib.stylix) colors;
    in
    {
      options.programs.terminal.enable = lib.mkEnableOption "Enable terminal module";

      config = lib.mkIf config.programs.terminal.enable {
        environment.systemPackages = [ pkgs.ghostty ];

        hjem.users.${username}.files.".config/ghostty/config".text = ''
          background-opacity = 0.5
          cursor-style = block
          cursor-style-blink = false
          shell-integration = detect
          font-size = 10
          background = #${colors.base00}
          foreground = #${colors.base05}
          cursor-color = #${colors.base05}
          selection-background = #${colors.base02}
          selection-foreground = #${colors.base05}
          palette = 0=#${colors.base00}
          palette = 1=#${colors.base08}
          palette = 2=#${colors.base0B}
          palette = 3=#${colors.base0A}
          palette = 4=#${colors.base0D}
          palette = 5=#${colors.base0E}
          palette = 6=#${colors.base0C}
          palette = 7=#${colors.base05}
          palette = 8=#${colors.base03}
          palette = 9=#${colors.base08}
          palette = 10=#${colors.base0B}
          palette = 11=#${colors.base0A}
          palette = 12=#${colors.base0D}
          palette = 13=#${colors.base0E}
          palette = 14=#${colors.base0C}
          palette = 15=#${colors.base07}
        '';
      };
    };
}
