_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username wallpaper;
    in
    {
      config = lib.mkIf config.mods.desktop.hypr.enable {
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
    };
}
