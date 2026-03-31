_: {
  flake.nixosModules.coreServicesGnome = {
    services.gnome.gnome-keyring = {
      enable = true;
    };
  };
}
