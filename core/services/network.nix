_: {
  flake.nixosModules.coreServicesNetwork = {
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
