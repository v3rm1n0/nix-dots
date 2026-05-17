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
        '';
      };
    };
}
