_: {
  flake.nixosModules.coreBootPlymouth = {
    boot.plymouth = {
      enable = true;
    };
  };
}
