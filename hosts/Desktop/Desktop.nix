{ inputs, ... }:
{
  flake.modules.nixos."host/Desktop" =
    { config, pkgs, ... }:
    {
      userOptions = {
        browser = "zen";
        colorScheme = "gruvbox-dark-hard";
        dots = "/home/${config.userOptions.username}/dotfiles";
        hostName = "Desktop";
        username = "v3rm1n";
        wallpaper = "rocket.png";
      };

      mods.apps = {
        ai.enable = true;
        browsing = {
          chromium = {
            enable = false;
            package = inputs.brave-origin.legacyPackages.${pkgs.stdenv.hostPlatform.system}.brave-origin;
          };
          firefox = {
            enable = true;
            package = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
          };
        };
        content.enable = true;
        tdarr.enable = true;
        dev.optionalPackages = [
          pkgs.zed-editor
        ];
        gaming.optionalPackages = [
          #pkgs.stoat-desktop
        ];
      };
    };
}
