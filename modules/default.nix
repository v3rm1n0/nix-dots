{ self, ... }:
{
  flake.nixosModules.modules = {
    imports = [
      self.nixosModules.modulesHardware
      self.nixosModules.modulesSecurity
      self.nixosModules.modulesServices
      self.nixosModules.modulesShell
    ];
  };
}
