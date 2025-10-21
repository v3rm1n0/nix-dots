{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.hardwareModule.razer = {
    enable = lib.mkEnableOption "Enable razer module";
  };

  config = lib.mkIf config.hardwareModule.razer.enable {
    hardware.openrazer.enable = true;
    environment.systemPackages = with pkgs; [
      openrazer-daemon
      polychromatic
    ];
  };
}
