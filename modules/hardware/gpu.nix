_: {
  flake.modules.nixos.default =
    { lib, ... }:
    {
      options.mods.hardware = {
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
    };
}
