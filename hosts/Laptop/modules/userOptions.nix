_: {
  flake.nixosModules.hostLaptopModulesUserOptions =
    { config, ... }:
    {
      config.userOptions = {
        browser = "helium";
        colorScheme = "gruvbox-dark-hard";
        dots = "/home/${config.userOptions.username}/dotfiles";
        hostName = "Laptop";
        username = "v3rm1n";
        wallpaper = "rocket.png";
      };
    };
}
