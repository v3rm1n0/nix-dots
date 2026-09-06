_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
    in
    {
      options.mods.apps.emulators.enable = lib.mkEnableOption "Enabled the emulation programs";

      config = lib.mkIf config.mods.apps.emulators.enable {
        environment.systemPackages = with pkgs; [ docker-compose ];

        hjem.users.${username}.packages = with pkgs; [
          qemu
          quickemu
          winboat
        ];

        programs.virt-manager.enable = true;
        users.users.${username}.extraGroups = [ "libvirtd" ];
        virtualisation = {
          docker = {
            enable = true;
            enableOnBoot = false;
          };
          libvirtd.enable = true;
          spiceUSBRedirection.enable = true;
        };
      };
    };
}
