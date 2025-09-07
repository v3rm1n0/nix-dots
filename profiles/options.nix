{ lib, ... }:

with lib;

{
  options.specs = {
    gpu = {
      enable = mkEnableOption "Enable GPU support";
      brand = mkOption {
        type = types.nullOr (
          types.enum [
            "nvidia"
            "amd"
            "intel"
          ]
        );
        default = null;
        example = "nvidia";
        description = "GPU brand/vendor. null means no vendor-specific config.";
      };
    };
  };
}
