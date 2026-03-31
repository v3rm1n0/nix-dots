{ inputs, ... }:
{
  flake.nixosModules.coreServicesNmapplet =
    { config, ... }:
    let
      inherit (config.userOptions) username;
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager.users.${username} = _: {
        services.network-manager-applet.enable = true;
      };
    };
}
