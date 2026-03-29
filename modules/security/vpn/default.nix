{ self, inputs, ... }:
{
  flake.nixosModules.modulesSecurityVpn =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.protonvpn-gui
      ];
    };
}
