{
  config,
  lib,
  vicinae,
  ...
}:
let
  username = config.userOptions.username;
in
{
  options.servicesModule.vicinae = {
    enable = lib.mkEnableOption "Enable vicinae service";
  };

  config = lib.mkIf config.servicesModule.vicinae.enable {
    home-manager.users.${username} = {

      imports = [ vicinae.homeManagerModules.default ];

      services.vicinae = {
        enable = true;
        autoStart = true;
        settings = {
          faviconService = "twenty";
          font.normal = "Geist";
          window = {
            csd = true;
            rounding = 10;
          };
        };
      };
    };
  };
}
