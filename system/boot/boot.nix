{
  lanzaboote,
  lib,
  ...
}:
{
  imports = [ lanzaboote.nixosModules.lanzaboote ];
  config = {
    boot = {
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
      loader = {
        systemd-boot.enable = lib.mkForce false;
        efi.canTouchEfiVariables = true;
      };
    };
    boot.tmp.cleanOnBoot = true;
  };
}
