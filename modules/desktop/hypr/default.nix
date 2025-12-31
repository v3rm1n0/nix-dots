{
  config,
  pkgs,
  ...
}:
let
  username = config.userOptions.username;
in 
{
  imports = [
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpanel.nix
    ./hyprpaper.nix
  ];

  environment = {
    systemPackages = with pkgs; [
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
      slurp
      wl-clipboard
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
}
