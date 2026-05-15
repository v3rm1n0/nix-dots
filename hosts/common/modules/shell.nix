_: {
  flake.nixosModules.hostCommonModulesShell = {
    config.shell = {
      fish.enable = true;
      zsh.enable = true;
    };
  };
}
