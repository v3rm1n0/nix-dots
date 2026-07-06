{ self, ... }:
{
  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      programs.nh = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.nh;
      };
    };
}
