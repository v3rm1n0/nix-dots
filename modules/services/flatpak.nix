_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      ...
    }:
    {
      options.mods.services.flatpak = {
        enable = lib.mkEnableOption "Enable flatpak service";
      };

      config = lib.mkIf config.mods.services.flatpak.enable {
        services.flatpak.enable = true;
      };
    };
}
