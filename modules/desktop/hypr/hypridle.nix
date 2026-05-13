_: {
  flake.nixosModules.modulesDesktopHyprHypridle =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
    in
    {
      config = lib.mkIf (config.userOptions.hostName == "Laptop") {
        hjem.users.${username} = {
          files.".config/hypr/hypridle.conf".text = ''
            general {
              after_sleep_cmd = hyprctl dispatch dpms on
              ignore_dbus_inhibit = false
              lock_cmd = hyprlock
            }
            listener {
              timeout = 300
              on-timeout = hyprctl dispatch dpms off
              on-resume = hyprctl dispatch dpms on
            }
            listener {
              timeout = 420
              on-timeout = hyprlock
            }
          '';

          systemd.services.hypridle = {
            description = "Hypridle idle daemon";
            after = [ "graphical-session.target" ];
            partOf = [ "graphical-session.target" ];
            wantedBy = [ "graphical-session.target" ];
            serviceConfig = {
              ExecStart = "${pkgs.hypridle}/bin/hypridle";
              Restart = "on-failure";
            };
          };
        };
      };
    };
}
