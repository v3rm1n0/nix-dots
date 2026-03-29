{ self, inputs, ... }:
{
  flake.nixosModules.coreHardwarePrinting =
    {
      pkgs,
      ...
    }:
    {
      services = {
        printing = {
          enable = true;
          #drivers = [ pkgs.cups-kyocera-ecosys-m552x-p502x ]; #TODO: Wait for pr merge https://github.com/NixOS/nixpkgs/pull/464716
        };
        avahi = {
          enable = false;
          nssmdns4 = true;
          openFirewall = true;
        };
      };
    };
}
