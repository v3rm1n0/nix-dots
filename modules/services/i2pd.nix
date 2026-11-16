_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      ...
    }:
    {
      options.mods.services.i2pd = {
        enable = lib.mkEnableOption "Enable the i2pd (I2P router) service";
      };

      config = lib.mkIf config.mods.services.i2pd.enable {
        services.i2pd = {
          enable = true;
          settings = {
            ipv4 = true;
            ipv6 = false;
            http = {
              address = "127.0.0.1";
              port = 7070;
            };
            httpproxy = {
              address = "127.0.0.1";
              port = 4444;
            };
            socksproxy = {
              address = "127.0.0.1";
              port = 4447;
            };
            sam = {
              enabled = true;
              address = "127.0.0.1";
              port = 7656;
            };
            i2cp = {
              enabled = true;
              address = "127.0.0.1";
              port = 7654;
            };
          };
        };
      };
    };
}
