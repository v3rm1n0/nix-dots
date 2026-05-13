_: {
  flake.nixosModules.applicationsElectron =
    { config, ... }:
    let
      inherit (config.userOptions) username;
    in
    {
      hjem.users.${username}.files.".config/electron-flags.conf".source = ./electron-flags.conf;
    };
}
