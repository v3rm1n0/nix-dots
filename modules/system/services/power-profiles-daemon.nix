_: {
  flake.modules.nixos.default = {
    services.power-profiles-daemon.enable = true;
  };
}
