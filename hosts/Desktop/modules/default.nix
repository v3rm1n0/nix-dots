{ self, ... }:
{
  flake.nixosModules.hostDesktopModules = {
    imports = [
      self.nixosModules.hostDesktopModulesHardware
    ];
  };
}
