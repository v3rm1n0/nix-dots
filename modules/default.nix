{ self, ... }:
{
  flake.nixosModules.modules = {
    imports = [
      self.nixosModules.modulesDesktop
      self.nixosModules.modulesHardware
      self.nixosModules.modulesSecurity
      self.nixosModules.modulesServices
      self.nixosModules.modulesShell
    ];
  };
}
