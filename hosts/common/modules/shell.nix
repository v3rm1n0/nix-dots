_: {
  flake.nixosModules.hostCommonModulesShell = {
    config.shell = {
      bash.enable = true;
      fish.enable = false;
      zsh.enable = true;
    };
  };
}
