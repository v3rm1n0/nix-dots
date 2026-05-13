{ self, inputs, ... }:
{
  flake.nixosModules.modulesDesktopHypr =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
    in
    {
      imports = [
        self.nixosModules.modulesDesktopHyprHypridle
        self.nixosModules.modulesDesktopHyprHyprland
        self.nixosModules.modulesDesktopHyprHyprlock
        self.nixosModules.modulesDesktopHyprHyprpaper
      ];

      environment.systemPackages = with pkgs; [
        brightnessctl
        grim
        gthumb
        hyprpaper
        libnotify
        nautilus
        networkmanagerapplet
        pavucontrol
        playerctl
        pywal
        satty
        slurp
        wayfreeze
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

      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        withUWSM = true;
      };

      programs.nautilus-open-any-terminal = {
        enable = true;
        terminal = "ghostty";
      };

      programs.uwsm.enable = true;
    };
}
