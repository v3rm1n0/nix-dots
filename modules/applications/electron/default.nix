{ config, ... }:
let
  username = config.userOptions.username;
in
{
  home-manager.users.${username} = {
    home.file = {
      ".config/electron-flags.conf".source = ./electron-flags.conf;
    };
  };
}
