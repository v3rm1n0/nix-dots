_: {
  flake.nixosModules.hostCommonModulesShell = {
    config.shell = {
      fish.enable = false;
      zsh.enable = true;
    };
  };
}
