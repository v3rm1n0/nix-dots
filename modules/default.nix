{ self, inputs, ... }:
{
  flake.nixosModules.modules = {
    imports = [
      self.nixosModules.modulesApplications
      self.nixosModules.modulesDesktop
      self.nixosModules.modulesHardware
      self.nixosModules.modulesSecurity
      self.nixosModules.modulesServices
      self.nixosModules.modulesShell
      self.nixosModules.modulesUser
    ];
  };
}
