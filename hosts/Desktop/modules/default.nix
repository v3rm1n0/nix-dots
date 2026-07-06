{ self, ... }:
{
  flake.nixosModules.hostDesktopModules = {
    imports = [
      self.nixosModules.hostDesktopModulesHardware
      self.nixosModules.hostDesktopModulesMonitors
    ];
  };
}
