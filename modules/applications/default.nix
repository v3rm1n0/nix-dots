{ self, ... }:
{
  flake.nixosModules.modulesApplications = {
    imports = [
      self.nixosModules.applicationsAi
      self.nixosModules.applicationsBrowsing
      self.nixosModules.applicationsComms
      self.nixosModules.applicationsContent
      self.nixosModules.applicationsDev
      self.nixosModules.applicationsElectron
      self.nixosModules.applicationsEmulators
      self.nixosModules.applicationsGaming
      self.nixosModules.applicationsMedia
      self.nixosModules.applicationsProductivity
      self.nixosModules.applicationsTerminal
      self.nixosModules.applicationsUni
    ];
  };
}
