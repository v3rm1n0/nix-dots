{ self, inputs, ... }:
{
  flake.nixosModules.coreServicesRtkit = {
    security.rtkit.enable = true;
  };
}
