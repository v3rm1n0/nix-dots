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

      mods.desktop.monitors = [
        {
          name = "DP-1";
          width = 1920;
          height = 1080;
          refreshRate = 180;
          x = 0;
          y = 0;
          workspaces = [
            1
            3
            4
            5
            6
            7
            8
          ];
          workspacePrimary = 1;
          enabled = true;
        }
        {
          name = "HDMI-A-2";
          width = 1920;
          height = 1080;
          refreshRate = 60;
          x = 1920;
          y = 0;
          workspaces = [
            2
            9
            10
          ];
          workspacePrimary = 2;
          enabled = true;
        }
      ];

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
