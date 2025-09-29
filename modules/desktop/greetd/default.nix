{ config, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    restart = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --greeting 'Welcome to Wonderland' --asterisks --cmd 'uwsm start hyprland-uwsm.desktop'";
        user = config.userOptions.username;
      };
    };
  };
}
