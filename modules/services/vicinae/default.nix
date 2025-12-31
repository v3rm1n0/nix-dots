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
      stylix.targets.vicinae.enable = false;
      imports = [ vicinae.homeManagerModules.default ];

      services.vicinae = {
        enable = true;
        systemd = {
          enable = true;
          autoStart = true;
          environment = {
            USE_LAYER_SHELL = 1;
          };
        };
        settings = {
          favicon_service = "twenty";
          font.normal.normal = "Geist";
          theme = {
            dark = {
              name = "kanagawa";
              icon_theme = "default";
            };
          };
          launcher_window = {
            opacity = 0.8;
          };
        };
      };
    };
  };
}
