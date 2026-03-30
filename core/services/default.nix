{ self, ... }:
{
  flake.nixosModules.coreServices = {
    imports = [
      self.nixosModules.coreServicesGnome
      self.nixosModules.coreServicesGvfs
      self.nixosModules.coreServicesNmapplet
      self.nixosModules.coreServicesPowerProfiles
      self.nixosModules.coreServicesRtkit
      self.nixosModules.coreServicesSsh
      self.nixosModules.coreServicesUpower
    ];
  };
}
