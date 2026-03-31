_: {
  flake.nixosModules.hostCommonModulesSecurity = {
    config.securityModule = {
      encryption = {
        passwords.enable = true;
      };
      gpg.enable = true;
    };
  };
}
