{ lib, ... }:
{
  options.hardwareModule = {
    gpu = {
      enable = lib.mkEnableOption "Enable GPU support";
      brand = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
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
