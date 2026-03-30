{ inputs, ... }:
{
  flake.nixosModules.coreProgramsMonitoringFastfetch =
    { config, pkgs, ... }:
    let
      username = config.userOptions.username;
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      environment.systemPackages = with pkgs; [ fastfetch ];

      home-manager.users.${username} = _: {
        home.file = {
          ".config/fastfetch/config.jsonc".source = ./config.jsonc;
        };
      };
    };
}
