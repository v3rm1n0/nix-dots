{ self, ... }:
{
  flake.nixosModules.coreProgramsUtilsNeovim =
    {
      lib,
      pkgs,
      ...
    }:
    {
      programs.neovim = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.neovimDynamic;
      };
    };
}
