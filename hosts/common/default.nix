{ self, ... }:
{
  flake.nixosModules.hostCommon = {
    imports = [
      self.nixosModules.hostCommonModules
    ];
  };
}
