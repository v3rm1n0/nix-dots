{ inputs, ... }:
{
  flake.nixosModules.modulesDesktopNoctalia =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (config.userOptions) username hostName wallpaper;
    in
    {
      imports = [ inputs.noctalia.nixosModules.default ];

      hjem.users.${username} = {
        files.".cache/noctalia/wallpapers.json" = {
          text = builtins.toJSON {
            defaultWallpaper = "/home/${username}/.config/backgrounds/${wallpaper}";
          };
        };

        files.".config/noctalia/config.json" = {
          generator = lib.generators.toJSON { };
          value = {
            settingsVersion = 63;
            bar = {
              barType = "floating";
              density = "compact";
              position = "top";
              showCapsule = false;
              widgets = {
                left = [
                  {
                    id = "ControlCenter";
                    useDistroLogo = true;
                  }
                  { id = "SystemMonitor"; }
                  {
                    id = "Workspace";
                    labelMode = "none";
                  }
                  {
                    id = "AudioVisualizer";
                    width = 100;
                    hideWhenIdle = true;
                  }
                  { id = "MediaMini"; }
                ];
                center = [
                  { id = "ActiveWindow"; }
                ];
                right = [
                  { id = "Volume"; }
                  { id = "Network"; }
                  { id = "Bluetooth"; }
                ]
                ++ lib.optional (hostName == "Laptop") { id = "Battery"; }
                ++ [
                  {
                    id = "KeyboardLayout";
                    showIcon = false;
                  }
                  { id = "Tray"; }
                  { id = "NotificationHistory"; }
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
            dock.enabled = false;
            general = {
              scaleRatio = 0.9;
              shadowDirection = "top_right";
            };
            location = {
              monthBeforeDay = false;
              name = "Viersen, Germany";
            };
          };
        };
      };
    };
}
