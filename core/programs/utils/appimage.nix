_: {
  flake.nixosModules.coreProgramsUtilsAppimage = {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
