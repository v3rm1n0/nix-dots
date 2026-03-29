{ self, inputs, ... }:
{
  flake.nixosModules.coreServicesPowerProfiles = {
    services.power-profiles-daemon.enable = true;
  };
}
