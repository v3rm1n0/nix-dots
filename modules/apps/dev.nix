_: {
  flake.modules.nixos.default =
    {
      lib,
      config,
      pkgs,
      ...
    }:

    with lib;

    let
      defaultPackages = [
        #--- Tools ---#
        pkgs.devenv
        pkgs.nix-output-monitor
      ];
    in
    {
      options.mods.apps.dev = {
        enable = mkEnableOption "Enable developer tools";

        optionalPackages = mkOption {
          type = types.listOf types.package;
          default = [ ];
          example = [
            pkgs.nodejs_latest
            pkgs.gitkraken
          ];
          description = "List of optional packages to install alongside the default ones.";
        };
      };

      config = mkIf config.mods.apps.dev.enable {
        environment.systemPackages = defaultPackages ++ config.mods.apps.dev.optionalPackages;
      };
    };
}
