{ config, ... }:
{
  config.userOptions = {
    browser = "brave";
    colorScheme = "kanagawa";
    discordClient = "equibop";
    dots = "/home/${config.userOptions.username}/.dotfiles";
    hostName = "Desktop";
    username = "v3rm1n";
    wallpaper = "kanagawa.png";
  };
}
