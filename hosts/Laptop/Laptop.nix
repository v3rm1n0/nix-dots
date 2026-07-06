{ inputs, ... }:
{
  flake.modules.nixos."host/Laptop" =
    { config, pkgs, ... }:
    {
      userOptions = {
        browser = "brave-origin";
        colorScheme = "gruvbox-dark-hard";
        dots = "/home/${config.userOptions.username}/dotfiles";
        hostName = "Laptop";
        username = "v3rm1n";
        wallpaper = "rocket.png";
      };

      mods.apps.browsing.chromium = {
        enable = true;
        package = inputs.brave-origin.legacyPackages.${pkgs.stdenv.hostPlatform.system}.brave-origin;
      };
    };
}
