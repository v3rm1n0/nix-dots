{
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      hostUsernames,
      userProfiles,
      ...
    }:
    let
      hyprUsers = builtins.filter (n: userProfiles.${n}.wm == "hyprland") hostUsernames;
    in
    {
      options.mods.desktop.hypr.enable = lib.mkOption {
        type = lib.types.bool;
        default = hyprUsers != [ ];
        description = "Enable the Hyprland desktop (hyprland, hyprlock, hyprpaper, polkit agent).";
      };

      config = lib.mkIf config.mods.desktop.hypr.enable (
        lib.mkMerge (
          [
            {
              environment.systemPackages = with pkgs; [
                brightnessctl
                gthumb
                hyprpaper
                libnotify
                nautilus
                networkmanagerapplet
                pavucontrol
                playerctl
                pywal
                satty
                wl-clipboard
                yazi
                zenity
              ];

              programs = {
                hyprland = {
                  enable = true;
                  xwayland.enable = true;
                  withUWSM = true;
                };

                nautilus-open-any-terminal = {
                  enable = true;
                  terminal = "ghostty";
                };

                uwsm.enable = true;
              };
            }
          ]
          ++ map (username: {
            hjem.users.${username}.systemd.services.hyprpolkitagent = {
              description = "Hyprland Polkit Authentication Agent";
              after = [ "graphical-session.target" ];
              partOf = [ "graphical-session.target" ];
              wantedBy = [ "graphical-session.target" ];
              serviceConfig = {
                ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
                Restart = "on-failure";
              };
            };
          }) hyprUsers
        )
      );
    };
}
