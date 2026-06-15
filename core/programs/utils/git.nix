_: {
  flake.nixosModules.coreProgramsUtilsGit = {
    programs.git = {
      enable = true;
      config = {
        commit.gpgsign = true;
        gpg.format = "openpgp";
        push.autoSetupRemote = "true";
        user = {
          name = "V3RM1N";
          email = "mail@v3rm1n.dev";
          signingkey = "04A465051516159B";
        };
      };
    };
  };
}
