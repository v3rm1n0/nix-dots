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
      defaultPackages = [
        pkgs.devenv
        pkgs.nix-output-monitor
        pkgs.secretspec
      ];
      users = builtins.filter (n: builtins.elem "dev" userProfiles.${n}.apps) hostUsernames;
    in
    {
      options.mods.apps.dev.optionalPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        example = [
          pkgs.nodejs_latest
          pkgs.gitkraken
        ];
        description = "List of optional packages to install alongside the default ones.";
      };

      config = lib.mkMerge (
        map (name: {
          hjem.users.${name}.packages = defaultPackages ++ config.mods.apps.dev.optionalPackages;
        }) users
      );
    };
}
