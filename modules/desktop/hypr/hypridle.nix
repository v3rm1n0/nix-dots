{ config, lib, ... }:
let
  username = config.userOptions.username;
in
{
  config = lib.mkIf (config.userOptions.hostName == "Laptop") {
    home-manager.users.${username} = {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "hyprlock";
          };
          listener = [
            {
              timeout = 400;
              on-timeout = "hyprlock";
            }
            {
              timeout = 180;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };
  };
}
