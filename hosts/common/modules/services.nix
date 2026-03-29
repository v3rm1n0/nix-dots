{ self, inputs, ... }:
{
  flake.nixosModules.hostCommonModulesServices = {
    config.servicesModule = {
      blueman.enable = true;
      flatpak.enable = true;
      vicinae.enable = true;
    };
  };
}
