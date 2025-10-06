{ config, pkgs, ... }:
{
  services.greetd = {
    enable = false;
    restart = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --greeting 'Welcome to Wonderland' --asterisks --cmd 'uwsm start hyprland-uwsm.desktop'";
        user = "${config.userOptions.username}";
      };
      default_session = initial_session;
    };
  };
}
