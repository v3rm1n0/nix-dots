{
  config,
  lib,
  ...
}:
{
  options.servicesModule.blueman = {
    enable = lib.mkEnableOption "Enable blueman service aka bluetooth";
  };

  config = lib.mkIf config.servicesModule.blueman.enable {
    services.blueman.enable = true;
  };
}
