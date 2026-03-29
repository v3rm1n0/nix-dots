{ self, inputs, ... }:
{
  flake.nixosModules.hostCommonModules = {
    imports = [
      self.nixosModules.hostCommonModulesPrograms
      self.nixosModules.hostCommonModulesSecurity
      self.nixosModules.hostCommonModulesServices
      self.nixosModules.hostCommonModulesShell
    ];
  };
}
