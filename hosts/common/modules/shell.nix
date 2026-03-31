_: {
  flake.nixosModules.hostCommonModulesShell = {
    config.shell = {
      zsh.enable = true;
    };
  };
}
