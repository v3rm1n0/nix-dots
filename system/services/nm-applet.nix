{ config, ... }:
let
  username = config.userOptions.username;
in
{
  home-manager.users.${username} = _: {
    services.network-manager-applet.enable = true;
  };
}
