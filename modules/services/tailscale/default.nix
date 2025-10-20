{
  config,
  lib,
  ...
}:
{
  options.servicesModule.tailscale = {
    enable = lib.mkEnableOption "Enable tailscale service";
  };

  config = lib.mkIf config.servicesModule.tailscale.enable {
    services.tailscale.enable = true;
  };
}
