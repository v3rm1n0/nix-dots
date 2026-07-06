_: {
  flake.modules.nixos.default = {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
