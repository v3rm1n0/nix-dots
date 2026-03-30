{ self, ... }:
{
  flake.nixosModules.coreBoot = {
    imports = [
      self.nixosModules.coreBootBoot
      self.nixosModules.coreBootKernel
      self.nixosModules.coreBootPlymouth
    ];
  };
}
