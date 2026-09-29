_: {
  flake.modules.nixos.default =
    { lib, config, ... }:
    {
      options.mods.boot.windowsBoot = {
        enable = lib.mkEnableOption "Windows dual-boot entry in the bootloader";
      };

      config = {
        boot = {
          loader = {
            limine = {
              enable = true;
              extraEntries = lib.mkIf config.mods.boot.windowsBoot.enable ''
                /Windows
                  protocol: efi
                  path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
              '';
              resolution = "1920x1080x32";
              secureBoot.enable = true;
              maxGenerations = 3;
            };
            efi.canTouchEfiVariables = true;
            timeout = 1;
          };
        };
        boot.tmp.cleanOnBoot = true;
      };
    };
}
