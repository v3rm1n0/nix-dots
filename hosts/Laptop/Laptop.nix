{ inputs, ... }:
{
  flake.modules.nixos."host/Laptop" =
    { config, pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_zen;

      userOptions = {
        browser = "brave-origin";
        colorScheme = "gruvbox-dark-hard";
        dots = "/home/${config.userOptions.username}/dotfiles";
        hostName = "Laptop";
        username = "v3rm1n";
        wallpaper = "rocket.png";
      };

      mods.hardware.gpu = {
        enable = true;
        brand = "intel";
      };

      mods.desktop = {
        hypr.hypridle.enable = true;
        noctalia.withBattery = true;
        monitors = [
          {
            name = "eDP-1";
            width = 1920;
            height = 1080;
            refreshRate = 180;
            x = 0;
            y = 0;
            workspaces = [
              1
              2
              3
              4
              5
              6
              7
              8
              9
            ];
            workspacePrimary = 1;
            enabled = true;
          }
          {
            name = "";
            width = 1920;
            height = 1080;
            refreshRate = 60;
            x = 1920;
            y = 0;
            workspaces = [ 10 ];
            workspacePrimary = 10;
            enabled = true;
          }
        ];
      };

      mods.apps.browsing.chromium = {
        enable = true;
        package = inputs.brave-origin.legacyPackages.${pkgs.stdenv.hostPlatform.system}.brave-origin;
      };
    };
}
