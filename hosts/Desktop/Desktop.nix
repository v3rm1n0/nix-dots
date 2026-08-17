{ ... }:
{
  flake.modules.nixos."host/Desktop" =
    { config, pkgs, ... }:
    {
      boot.initrd = {
        availableKernelModules = [
          "usb_storage"
        ];
        systemd.enable = true;
      };

      boot.kernelPackages = pkgs.linuxPackages_zen;

      userOptions = {
        browser = "librewolf";
        colorScheme = "gruvbox-dark-hard";
        dots = "/home/${config.userOptions.username}/dotfiles";
        hostName = "Desktop";
        username = "v3rm1n";
        wallpaper = "rocket.png";
      };

      mods = {
        apps = {
          ai.enable = true;
          browsing = {
            firefox = {
              enable = true;
              package = pkgs.librewolf;
            };
          };
          content.enable = true;
          tdarr.enable = true;
          dev.optionalPackages = [
            pkgs.zed-editor
          ];
          gaming.optionalPackages = [
            pkgs.arnis
            pkgs.edhm-ui
            pkgs.stoat-desktop
          ];
        };
        hardware = {
          gpu = {
            enable = true;
            brand = "nvidia";
          };
          razer.enable = false;
        };
      };

      mods.desktop.monitors = [
        {
          name = "DP-1";
          width = 1920;
          height = 1080;
          refreshRate = 180;
          x = 0;
          y = 0;
          bitdepth = 10;
          cm = "dcip3";
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
          bitdepth = 10;
          cm = "dcip3";
          workspaces = [
            2
            9
            10
          ];
          workspacePrimary = 2;
          enabled = true;
        }
      ];
    };
}
