{ self, inputs, ... }:
{
  flake.nixosModules.coreServicesGnome = {
    services.gnome.gnome-keyring = {
      enable = true;
    };
  };
}
