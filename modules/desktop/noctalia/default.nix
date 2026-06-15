{ inputs, ... }:
{
  flake.nixosModules.modulesDesktopNoctalia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username hostName wallpaper;
      colors = config.lib.stylix.colors;

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
                    showCpuTemp = false;
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
          colors = with colors.withHashtag; {
            mPrimary = base0D;
            mOnPrimary = base00;
            mSecondary = base0E;
            mOnSecondary = base00;
            mTertiary = base0C;
            mOnTertiary = base00;
            mError = base08;
            mOnError = base00;
            mSurface = base00;
            mOnSurface = base05;
            mHover = base0C;
            mOnHover = base00;
            mSurfaceVariant = base01;
            mOnSurfaceVariant = base04;
            mOutline = base03;
            mShadow = base00;
          };
        };
    in
    {
      environment.systemPackages = [
        (mkNoctalia { withBattery = hostName == "Laptop"; })
      ];

      hjem.users.${username} = {
        files.".cache/noctalia/wallpapers.json" = {
          text = builtins.toJSON {
            defaultWallpaper = "/home/${username}/.config/backgrounds/${wallpaper}";
          };
        };
      };
    };
}
