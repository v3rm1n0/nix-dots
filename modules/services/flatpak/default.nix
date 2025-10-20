{
  config,
  lib,
  ...
}:
{
  options.servicesModule.flatpak = {
    enable = lib.mkEnableOption "Enable flatpak service";
  };

  config = lib.mkIf config.servicesModule.flatpak.enable {
    services.flatpak.enable = true;
  };
}
