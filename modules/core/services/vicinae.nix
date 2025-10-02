{ config, vicinae, ... }:
let
  username = config.userOptions.username;
in
{
  home-manager.users.${username} = {

    imports = [ vicinae.homeManagerModules.default ];

    services.vicinae = {
      enable = true; # default: false
      autoStart = true; # default: true
      settings = {
        theme.name = "gruvbox_material_medium_dark.json";
        window.csd = false;
      };
    };
  };
}
