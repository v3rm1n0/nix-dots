{ self, inputs, ... }:
{
  flake.nixosModules.applicationsElectron =
    { config, ... }:
    let
      username = config.userOptions.username;
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager.users.${username} = {
        home.file = {
          ".config/electron-flags.conf".source = ./electron-flags.conf;
        };
      };
    };
}
