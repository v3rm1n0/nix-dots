{ config, ... }:
let
  username = config.userOptions.username;
in 
{
  users.users.${username} = {
    openssh.authorizedKeys.keys = [
    ];
  };
}
