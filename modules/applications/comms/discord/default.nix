{ inputs, self, ... }:
{
  flake.nixosModules.applicationsCommsDiscord =
    { config, lib, ... }:
    let
      username = config.userOptions.username;
    in
    {
      home-manager.users.${username} = {
        imports = [ inputs.nixcord.homeModules.nixcord ];
        programs.nixcord = {
          enable = true;
          discord.enable = lib.mkDefault false;
          equibop.enable = lib.mkDefault true;
        };
      };
    };
}
