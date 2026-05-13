{ self, ... }:
{
  flake.nixosModules.coreProgramsUtils = {
    imports = [
      self.nixosModules.coreProgramsUtilsAppimage
      self.nixosModules.coreProgramsUtilsLocalsend
      self.nixosModules.coreProgramsUtilsNeovim
      self.nixosModules.coreProgramsUtilsNh
      self.nixosModules.coreProgramsUtilsRclone
      self.nixosModules.coreProgramsUtilsRipgrep
    ];
  };
}
