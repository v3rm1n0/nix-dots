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
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ "/home/${username}/.config/backgrounds/${wallpaper}" ];
        wallpaper = [
          " , ~/.config/backgrounds/${wallpaper}"
        ];
      };
    };
  };
}
