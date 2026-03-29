{ inputs, ... }:
{
  flake.nixosModules.applicationsTerminal =
    { config, lib, ... }:
    let
      username = config.userOptions.username;
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      options.programs.terminal = {
        enable = lib.mkEnableOption "Enable terminal module";
      };

      config = lib.mkIf config.programs.terminal.enable {
        home-manager.users.${username} = {
          programs.ghostty = {
            enable = true;
            enableZshIntegration = true;
            settings = {
              background-opacity = 0.5;
              cursor-style = "block";
              cursor-style-blink = false;
            };
          };
        };
      };
    };
}
