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
        inputs.home-manager.nixosModules.home-manager

        self.nixosModules.modulesDesktopHyprHypridle
        self.nixosModules.modulesDesktopHyprHyprland
        self.nixosModules.modulesDesktopHyprHyprlock
        self.nixosModules.modulesDesktopHyprHyprpanel
        self.nixosModules.modulesDesktopHyprHyprpaper
      ];

      environment = {
        systemPackages = with pkgs; [
          brightnessctl
          gthumb
          hyprpaper
          hyprshot
          libnotify
          nautilus
          networkmanagerapplet
          pavucontrol
          playerctl
          pywal
          wl-clipboard
          yazi
          zenity
        ];
      };

      home-manager.users.${username} = {
        services.hyprpolkitagent.enable = true;
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

      programs.uwsm = {
        enable = true;
      };
    };
}
