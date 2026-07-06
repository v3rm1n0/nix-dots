_: {
  flake.modules.nixos.default = {
    boot.plymouth = {
      enable = true;
    };
  };
}
