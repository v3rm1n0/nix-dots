{ self, ... }:
{
  flake.nixosModules.coreProgramsUtilsNh =
    { pkgs, ... }:
    {
      programs.nh = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.nh;
      };
    };
}
