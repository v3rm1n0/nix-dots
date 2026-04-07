_: {
  flake.nixosModules.modulesSecurityVpn =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.proton-vpn
      ];
    };
}
