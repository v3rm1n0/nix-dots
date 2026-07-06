_: {
  flake.modules.nixos.default = {
    services.gvfs.enable = true;
  };
}
