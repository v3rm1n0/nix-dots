{ self, ... }:
{
  flake.nixosModules.hostCommonModules = {
    imports = [
      self.nixosModules.hostCommonModulesSecurity
      self.nixosModules.hostCommonModulesServices
      self.nixosModules.hostCommonModulesShell
    ];
  };
}
