{ self, inputs, ... }:
{
  flake.nixosModules.modulesServices = {
    imports = [
      self.nixosModules.modulesServicesBlueman
      self.nixosModules.modulesServicesFlatpak
      self.nixosModules.modulesServicesVicinae
    ];
  };
}
