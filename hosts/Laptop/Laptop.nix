{
  flake.modules.nixos."host/Laptop" =
    { config, ... }:
    {
      userOptions = {
        browser = "brave-origin";
        colorScheme = "gruvbox-dark-hard";
        dots = "/home/${config.userOptions.username}/dotfiles";
        hostName = "Laptop";
        username = "v3rm1n";
        wallpaper = "rocket.png";
      };
    };
}
