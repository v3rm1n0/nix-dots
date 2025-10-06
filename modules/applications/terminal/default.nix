{
  config,
  lib,
  ...
}:
let
  username = config.userOptions.username;
in
{
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
          font-family = "GeistMono Nerd Font";
          font-size = 12;
        };
      };
    };
  };
}
