{ ... }:
{
  flake.nixosModules.hostDesktopModulesUserOptions =
    { config, ... }:
    {
      config.userOptions = {
        browser = "brave";
        colorScheme = "gruvbox-dark-hard";
        dots = "/home/${config.userOptions.username}/dotfiles";
        hostName = "Desktop";
        username = "v3rm1n";
        wallpaper = "rocket.png";
      };
    };
}
