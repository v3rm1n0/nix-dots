{ self, ... }:
{
  flake.nixosModules.coreProgramsUtilsNeovim =
    {
      pkgs,
      ...
    }:
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.neovimDynamic;
      };
    };
}
