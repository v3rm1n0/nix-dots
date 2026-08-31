_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      hostUsernames,
      userProfiles,
      ...
    }:
    let
      defaultPackages = [ ];
      users = builtins.filter (n: builtins.elem "content" userProfiles.${n}.apps) hostUsernames;
    in
    {
      options.mods.apps.content.optionalPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        example = [
          pkgs.davinci-resolve-studio
        ];
        description = "List of optional packages to install alongside the default ones.";
      };

      config = lib.mkMerge (
        [
          (lib.mkIf (users != [ ]) {
            programs.obs-studio = {
              enable = true;
              package = pkgs.obs-studio.override { cudaSupport = true; };
              plugins = with pkgs.obs-studio-plugins; [
                wlrobs
                obs-vaapi
                obs-vkcapture
                obs-pipewire-audio-capture
              ];
            };
          })
        ]
        ++ map (name: {
          hjem.users.${name}.packages = defaultPackages ++ config.mods.apps.content.optionalPackages;
        }) users
      );
    };
}
