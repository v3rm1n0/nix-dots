{ inputs, ... }:
{
  flake.nixosModules.modulesDesktopHyprHypridle =
    { config, lib, ... }:
    let
      inherit (config.userOptions) username;
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
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
                  # Turn off screen after 5 min of idle (battery)
                  timeout = 300;
                  on-timeout = "hyprctl dispatch dpms off";
                  on-resume = "hyprctl dispatch dpms on";
                }
                {
                  # Lock 2 min after screen off
                  timeout = 420;
                  on-timeout = "hyprlock";
                }
              ];
            };
          };
        };
      };
    };
}
