{ config, ... }:
{
  config.userOptions = {
    browser = "librewolf";
    colorScheme = "kanagawa";
    dots = "/home/${config.userOptions.username}/.dotfiles";
    hostName = "Desktop";
    username = "v3rm1n";
    wallpaper = "kanagawa.png";
  };
}
