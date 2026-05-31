{ inputs, ... }:
{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      mkNoctalia =
        {
          withBattery ? false,
        }:
        inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
          inherit pkgs;
          package = pkgs.noctalia-shell.overrideAttrs {
            name = "v3noctalia";
          };
          settings = {
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
                  {
                    id = "SystemMonitor";
                    showMemoryUsage = true;
                    showNetworkStats = true;
                  }
                  {
                    id = "Workspace";
                    labelMode = "index";
                    showApplications = true;
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
                ++ lib.optional withBattery { id = "Battery"; }
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
    in
    {
      packages = {
        noctalia-shell = mkNoctalia { };
        noctalia-shell-laptop = mkNoctalia { withBattery = true; };
      };
    };
}
