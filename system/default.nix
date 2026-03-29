{ self, ... }:
{

  flake.nixosModules.core = {
    imports = [
      self.nixosModules.coreBoot
      self.nixosModules.coreHardware
      self.nixosModules.coreNix
      self.nixosModules.corePrograms
      self.nixosModules.coreServices
    ];
  };
}
