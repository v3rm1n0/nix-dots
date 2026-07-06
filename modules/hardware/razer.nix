_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.mods.hardware.razer = {
        enable = lib.mkEnableOption "Enable razer module";
      };

      config = lib.mkIf config.mods.hardware.razer.enable {
        hardware.openrazer.enable = true;
        environment.systemPackages = with pkgs; [
          openrazer-daemon
          polychromatic
        ];
      };
    };
}
