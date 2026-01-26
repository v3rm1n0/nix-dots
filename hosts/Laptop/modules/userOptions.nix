{ config, ... }:
{
  config.userOptions = {
    browser = "helium";
    colorScheme = "kanagawa";
    discordClient = "equibop";
    dots = "/home/${config.userOptions.username}/.dotfiles";
    hostName = "Laptop";
    username = "v3rm1n";
    wallpaper = "kanagawa.png";
  };
}
