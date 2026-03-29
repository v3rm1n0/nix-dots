{ self, inputs, ... }:
{
  flake.nixosModules.coreProgramsUtilsAppimage = {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
