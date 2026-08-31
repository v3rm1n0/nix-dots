_: {
  flake.modules.nixos.default =
    {
      lib,
      pkgs,
      hostUsernames,
      userProfiles,
      ...
    }:
    let
      users = builtins.filter (n: builtins.elem "emulators" userProfiles.${n}.apps) hostUsernames;
    in
    {
      config = lib.mkMerge (
        [
          (lib.mkIf (users != [ ]) {
            environment.systemPackages = with pkgs; [ docker-compose ];

            programs.virt-manager.enable = true;
            virtualisation = {
              docker = {
                enable = true;
                enableOnBoot = false;
              };
              libvirtd.enable = true;
              spiceUSBRedirection.enable = true;
            };
          })
        ]
        ++ map (name: {
          hjem.users.${name}.packages = with pkgs; [
            qemu
            quickemu
            winboat
          ];
          users.users.${name}.extraGroups = [ "libvirtd" ];
        }) users
      );
    };
}
