{ ... }:
{
  flake.nixosModules.coreBootBoot =
    { lib, ... }:
    {
      config = {
        boot = {
          loader = {
            limine = {
              enable = true;
              extraEntries = ''
                /Windows
                  protocol: efi
                  path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
              '';
              resolution = "1920x1080x32";
              secureBoot.enable = true;
            };
            systemd-boot.enable = lib.mkForce false;
            efi.canTouchEfiVariables = true;
          };
        };
        boot.tmp.cleanOnBoot = true;
      };
    };
}
