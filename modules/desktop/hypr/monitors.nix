{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.monitors = mkOption {
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
          workspaces = mkOption {
            type = types.listOf (types.int);
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
}
