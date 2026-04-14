_: {
  flake.nixosModules.hostDesktopModulesUserOptions =
    { config, ... }:
    {
      config.userOptions = {
        browser = "librewolf";
        colorScheme = "gruvbox-dark-hard";
        dots = "/home/${config.userOptions.username}/dotfiles";
        hostName = "Desktop";
        username = "v3rm1n";
        wallpaper = "rocket.png";
      };
    };
}
