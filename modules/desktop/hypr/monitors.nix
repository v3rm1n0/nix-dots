_: {
  flake.modules.nixos.default =
    { lib, ... }:
    let
      inherit (lib) mkOption types;
    in
    {
      options.mods.desktop.monitors = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              name = mkOption {
                type = types.str;
                example = "DP-1";
              };
              width = mkOption {
                type = types.int;
                example = 1920;
              };
              height = mkOption {
                type = types.int;
                example = 1080;
              };
              scale = mkOption {
                type = types.int;
                default = 1;
                example = 1;
              };
              refreshRate = mkOption {
                type = types.int;
                example = 60;
              };
              x = mkOption {
                type = types.int;
                example = 0;
              };
              y = mkOption {
                type = types.int;
                example = 0;
              };
              vrr = mkOption {
                type = types.int;
                default = 0;
                example = 1;
              };
              bitdepth = mkOption {
                type = types.int;
                default = 8;
                example = 10;
              };
              cm = mkOption {
                type = types.str;
                default = "srgb";
                example = "wide";
              };
              workspaces = mkOption {
                type = types.listOf types.int;
                example = [
                  1
                  2
                  3
                ];
              };
              workspacePrimary = mkOption {
                type = types.int;
                example = 1;
              };
              enabled = mkOption {
                type = types.bool;
                example = true;
              };
            };
          }
        );
        default = [ ];
      };
    };
}
