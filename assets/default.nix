{ self, inputs, ... }:
{

  flake.nixosModules.assets =
    { config, ... }:
    let
      username = config.userOptions.username;
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager.users.${username} = _: {
        home.file = {
          ".config/backgrounds".source = ./wallpapers;
          ".config/nixlogo.png".source = ./logo/nix-snowflake.png;
        };
      };
    };
}
