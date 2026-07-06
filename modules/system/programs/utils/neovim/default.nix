{ self, ... }:
{
  flake.modules.nixos.default =
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
