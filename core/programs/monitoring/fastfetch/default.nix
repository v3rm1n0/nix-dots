{ self, ... }:
{
  flake.nixosModules.coreProgramsMonitoringFastfetch =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.fastfetch
      ];
    };
}
