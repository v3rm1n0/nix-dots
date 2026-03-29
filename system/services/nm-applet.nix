{ self, inputs, ... }:
{
  flake.nixosModules.coreServicesNmapplet =
    { config, ... }:
    let
      username = config.userOptions.username;
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager.users.${username} = _: {
        services.network-manager-applet.enable = true;
      };
    };
}
