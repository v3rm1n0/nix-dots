{ self, inputs, ... }:
{
  flake.nixosModules.coreServicesGvfs = {
    services.gvfs.enable = true;
  };
}
