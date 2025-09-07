{
  config,
  lanzaboote,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.specs;
in
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
        systemd-boot.extraEntries."windows.conf" = ''
          title   Windows
          efi     /EFI/Microsoft/Boot/bootmgfw.efi
        '';
        grub = {
          enable = false;
          device = if cfg.boot.isDevDrive then "/dev/sda" else "nodev";
          efiSupport = true;
          useOSProber = true;
          gfxmodeBios = "1920x1080";
          gfxmodeEfi = "1920x1080";
          theme = pkgs.stdenv.mkDerivation {
            pname = "distro-grub-themes";
            version = "3.1";
            src = pkgs.fetchFromGitHub {
              owner = "AdisonCavani";
              repo = "distro-grub-themes";
              rev = "v3.1";
              hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
            };
            installPhase = "cp -r customize/nixos $out";
          };
        };
        efi.canTouchEfiVariables = true;
      };
    };
    boot.tmp.cleanOnBoot = true;
  };
}
