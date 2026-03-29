{ self, inputs, ... }:
{
  flake.nixosModules.hostLaptopModules = {
    imports = [
      self.nixosModules.hostLaptopModulesHardware
      self.nixosModules.hostLaptopModulesMonitors
      self.nixosModules.hostLaptopModulesPrograms
      self.nixosModules.hostLaptopModulesUserOptions
    ];
  };
}
