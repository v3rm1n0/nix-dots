{ inputs, ... }:
{
  flake.nixosModules.modulesDesktopNoctalia =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (config.userOptions) username;
      inherit (config.userOptions) hostName;
      inherit (config.userOptions) wallpaper;
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager.users.${username} = {
        imports = [
          inputs.noctalia.homeModules.default
        ];

        home.file.".cache/noctalia/wallpapers.json" = {
          text = builtins.toJSON {
            defaultWallpaper = "/home/${username}/.config/backgrounds/${wallpaper}";
          };
        };

        programs.noctalia-shell = {
          enable = true;
          systemd.enable = true;
          settings = {
            bar = {
              density = "compact";
              position = "top";
              showCapsule = false;
              widgets = {
                left = [
                  {
                    id = "ControlCenter";
                    useDistroLogo = true;
                  }
                  {
                    #hideUnoccupied = false;
                    id = "Workspace";
                    labelMode = "none";
                  }
                  {
                    id = "AudioVisualizer";
                    width = 100;
                    hideWhenIdle = true;
                  }
                  {
                    id = "MediaMini";
                  }
                ];
                center = [
                  {
                    id = "ActiveWindow";
                  }
                ];
                right = [
                  {
                    id = "Volume";
                  }
                  {
                    id = "Network";
                  }
                  {
                    id = "Bluetooth";
                  }
                  (lib.mkIf (hostName == "Laptop") { id = "Battery"; })
                  {
                    id = "KeyboardLayout";
                    showIcon = false;
                  }
                  {
                    id = "Tray";
                  }
                  {
                    id = "NotificationHistory";
                  }
                  {
                    formatHorizontal = "HH:mm";
                    formatVertical = "HH mm";
                    id = "Clock";
                    useMonospacedFont = true;
                    usePrimaryColor = true;
                  }
                ];
              };
            };
            colorSchemes.predefinedScheme = "kanagawa";
            dock = {
              enabled = false;
            };
            general = {
              scaleRatio = 0.9;
              shadowDirection = "top_right";
            };
            location = {
              monthBeforeDay = false;
              name = "Viersen, Germany";
            };
          };
          # this may also be a string or a path to a JSON file.
        };
      };
    };
}
