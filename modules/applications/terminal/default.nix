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
    in
    {
      options.programs.terminal.enable = lib.mkEnableOption "Enable terminal module";

      config = lib.mkIf config.programs.terminal.enable {
        environment.systemPackages = [ pkgs.ghostty ];

        hjem.users.${username}.files.".config/ghostty/config".text = ''
          background-opacity = 0.5
          cursor-style = block
          cursor-style-blink = false
          shell-integration = zsh
          font-size = 10
        '';
      };
    };
}
