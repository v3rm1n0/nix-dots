_: {
  flake.nixosModules.hostCommonModulesShell = {
    config.shell = {
      bash.enable = true;
      fish.enable = true;
      zsh.enable = true;
    };
  };
}
