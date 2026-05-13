{ ... }:
{
  flake.nixosModules.assets =
    { config, ... }:
    let
      inherit (config.userOptions) username;
    in
    {
      hjem.users.${username}.files = {
        ".config/backgrounds".source = ./wallpapers;
        ".config/nixlogo.png".source = ./logo/nix-snowflake.png;
      };
    };
}
