{ self, ... }:
{
  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.fastfetch
      ];
    };
}
