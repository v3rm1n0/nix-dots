_: {
  flake.modules.nixos.default =
    { config, lib, ... }:
    let
      inherit (config.userOptions) hostName;
    in
    {
      config = {
        boot = {
          loader = {
            limine = {
              enable = lib.mkIf (hostName == "Desktop") true;
              extraEntries = ''
                /Windows
                  protocol: efi
                  path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
              '';
              resolution = "1920x1080x32";
              secureBoot.enable = true;
            };
            systemd-boot.enable = lib.mkIf (hostName == "Laptop") true;
            efi.canTouchEfiVariables = true;
          };
        };
        boot.tmp.cleanOnBoot = true;
      };
    };
}
