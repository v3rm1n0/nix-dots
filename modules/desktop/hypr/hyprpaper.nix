{
  config,
  ...
}:
let
  username = config.userOptions.username;
  wallpaper = config.userOptions.wallpaper;
in
{
  home-manager.users.${username} = _: {
    stylix.targets.hyprpaper.enable = false;
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ "/home/${username}/.config/backgrounds/${wallpaper}" ];
        wallpaper = [
          {
            monitor = "";
            path = "~/.config/backgrounds/${wallpaper}";
            fit_mode = "cover";
          }
        ];
      };
    };
  };
}
