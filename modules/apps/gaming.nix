_: {
  flake.modules.nixos.default =
    {
      lib,
      config,
      pkgs,
      hostUsernames,
      userProfiles,
      ...
    }:
    let
      defaultPackages = with pkgs; [
        ed-odyssey-materials-helper
        heroic-unwrapped
        prismlauncher
      ];
      users = builtins.filter (n: builtins.elem "gaming" userProfiles.${n}.apps) hostUsernames;
    in
    {
      options.mods.apps.gaming.optionalPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        example = [
          pkgs.lunar-client
        ];
        description = "List of additional optional packages for gaming";
      };

      config = lib.mkMerge (
        [
          (lib.mkIf (users != [ ]) {
            programs = {
              steam = {
                enable = true;
                protontricks.enable = true;
              };
              gamemode.enable = true;
              gamescope.enable = true;
            };

            hardware.steam-hardware.enable = true;

            services.udev.extraRules = ''
              SUBSYSTEM=="hidraw", ATTRS{idVendor}=="044f", ATTRS{idProduct}=="b10a", TAG+="uaccess"
            '';
          })
        ]
        ++ map (name: {
          hjem.users.${name}.packages = defaultPackages ++ config.mods.apps.gaming.optionalPackages;
        }) users
      );
    };
}
