{ config, ... }:
let
  username = config.userOptions.username;
in
{
  home-manager.users.${username} = {
    programs.hyprlock = {
      enable = true;
    };
  };
}
