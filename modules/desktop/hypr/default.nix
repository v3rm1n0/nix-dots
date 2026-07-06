{
  flake.modules.nixos.default =
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
      options.mods.desktop.hypr.enable =
        lib.mkEnableOption "the Hyprland desktop (hyprland, hyprlock, hyprpaper, polkit agent)";

      config = lib.mkIf config.mods.desktop.hypr.enable {
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
      };
    };
}
