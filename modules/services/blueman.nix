_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      ...
    }:
    {
      options.mods.services.blueman = {
        enable = lib.mkEnableOption "Enable blueman service aka bluetooth";
      };

      config = lib.mkIf config.mods.services.blueman.enable {
        services.blueman.enable = true;
      };
    };
}
