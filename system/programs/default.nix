{ self, inputs, ... }:
{
  flake.nixosModules.corePrograms = {
    imports = [
      self.nixosModules.coreProgramsMonitoring
      self.nixosModules.coreProgramsUtils
    ];
  };
}
