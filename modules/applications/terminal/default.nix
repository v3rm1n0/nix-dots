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
      programs.wezterm = {
        enable = true;
        enableZshIntegration = true;
        extraConfig = ''
          return {
            font = wezterm.font("GeistMono Nerd Font"),
            font_size = 10.0,
            color_scheme = 'Kanagawa (Gogh)',
            enable_tab_bar = false,
            window_background_opacity = 0.5
          }
        '';
      };
    };
  };
}
