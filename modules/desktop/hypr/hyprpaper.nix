_: {
  flake.nixosModules.modulesDesktopHyprHyprpaper =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username wallpaper;
    in
    {
      hjem.users.${username} = {
        files.".config/hypr/hyprpaper.conf".text = ''
          preload = /home/${username}/.config/backgrounds/${wallpaper}
          splash = false
          wallpaper = ,~/.config/backgrounds/${wallpaper}
        '';

        systemd.services.hyprpaper = {
          description = "Hyprpaper wallpaper daemon";
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
            Restart = "on-failure";
          };
        };
      };
    };
}
