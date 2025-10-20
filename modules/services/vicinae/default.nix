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
          theme.name = "gruvbox_material_medium_dark.json";
          window.csd = false;
        };
      };
    };
  };
}
