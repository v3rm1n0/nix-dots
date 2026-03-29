{ self, ... }:
{
  flake.nixosModules.hostDesktopModules = {
    imports = [
      self.nixosModules.hostDesktopModulesHardware
      self.nixosModules.hostDesktopModulesMonitors
      self.nixosModules.hostDesktopModulesPrograms
      self.nixosModules.hostDesktopModulesUserOptions
    ];
  };
}
