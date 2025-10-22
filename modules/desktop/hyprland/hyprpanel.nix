{
  config,
  lib,
  ...
}:
let
  username = config.userOptions.username;
  hostName = config.userOptions.hostName;
  wallpaper = config.userOptions.wallpaper;
in
{
  home-manager.users.${username} = {
    programs.hyprpanel = {
      enable = true;
      settings = {
        bar.layouts = {
          "0" = {
            left = [
              "dashboard"
              "workspaces"
              "cava"
            ];
            middle = [ "windowtitle" ];
            right = [
              "volume"
              "kbinput"
              (lib.mkIf (hostName == "Laptop") "battery")
              "network"
              "bluetooth"
              "systray"
              "clock"
              "notifications"
            ];
          };
          "1" = {
            left = [
              "dashboard"
              "workspaces"
              "cava"
            ];
            middle = [ "windowtitle" ];
            right = [
              "volume"
              "kbinput"
              "network"
              "bluetooth"
              "systray"
              "clock"
              "notifications"
            ];
          };
        };
        bar.clock.format = "%a %b %d %R";
        bar.launcher.autoDetectIcon = true;
        bar.windowtitle.icon = false;
        bar.workspaces.show_numbered = true;
        bar.workspaces.workspaces = 2;
        menus.clock.time.military = true;
        menus.clock.weather.key = "/home/${username}/.config/apikey.json";
        menus.clock.weather.location = "Viersen";
        menus.clock.weather.unit = "metric";
        theme.bar.buttons.background_opacity = "100";
        theme.bar.buttons.padding_x = "0.3rem";
        theme.bar.buttons.padding_y = "0rem";
        theme.bar.floating = true;
        theme.bar.margin_bottom = "0.5em";
        theme.bar.margin_sides = "1em";
        theme.bar.menus.opacity = "90";
        theme.bar.outer_spacing = "0.4em";
        theme.bar.transparent = false;
        theme.font.size = "0.7rem";
        theme.matugen = false;
        wallpaper.enable = false;
      };
    };
  };
}
