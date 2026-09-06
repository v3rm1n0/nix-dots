_: {
  flake.modules.nixos.default =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      defaultPackages = [
        #--- Tools ---#
        pkgs.devenv
        pkgs.nix-output-monitor
        pkgs.secretspec
      ];
    in
    {
      options.mods.apps.dev = {
        enable = lib.mkEnableOption "Enable developer tools";

        optionalPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          example = [
            pkgs.nodejs_latest
            pkgs.gitkraken
          ];
          description = "List of optional packages to install alongside the default ones.";
        };
      };

      config = lib.mkIf config.mods.apps.dev.enable {
        environment.systemPackages = defaultPackages ++ config.mods.apps.dev.optionalPackages;
      };
    };
}
