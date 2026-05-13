_: {
  flake.nixosModules.coreProgramsMonitoringFastfetch =
    { config, pkgs, ... }:
    let
      inherit (config.userOptions) username;
    in
    {
      environment.systemPackages = with pkgs; [ fastfetch ];
      hjem.users.${username}.files.".config/fastfetch/config.jsonc".source = ./config.jsonc;
    };
}
