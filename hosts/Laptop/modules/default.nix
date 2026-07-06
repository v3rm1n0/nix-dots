{ self, ... }:
{
  flake.nixosModules.hostLaptopModules = {
    imports = [
      self.nixosModules.hostLaptopModulesHardware
      self.nixosModules.hostLaptopModulesMonitors
    ];
  };
}
