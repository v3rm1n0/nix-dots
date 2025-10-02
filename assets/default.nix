{ config, ... }:
let
  username = config.userOptions.username;
in
{
  home-manager.users.${username} = _: {
    home.file = {
      ".config/backgrounds".source = ./wallpapers;
      ".config/nixlogo.png".source = ./logo/nix-snowflake.png;
    };
  };
}
