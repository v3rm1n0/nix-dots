_: {
  flake.modules.nixos.default = {
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
