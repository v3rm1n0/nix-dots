_: {
  flake.modules.nixos.default = {
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
