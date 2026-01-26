{
  config,
  lib,
  noctalia,
  ...
}:
let
  username = config.userOptions.username;
  hostName = config.userOptions.hostName;
  wallpaper = config.userOptions.wallpaper;
in
{
  home-manager.users.${username} = {
    imports = [
      noctalia.homeModules.default
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
        general = {
          scaleRatio = 0.9;
        };
        location = {
          monthBeforeDay = false;
          name = "Viersen, Germany";
        };
      };
      # this may also be a string or a path to a JSON file.
    };
  };
}
