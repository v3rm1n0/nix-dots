{ inputs, ... }:
{
  flake.nixosModules.modulesDesktopHyprHyprpaper =
    {
      config,
      ...
    }:
    let
      inherit (config.userOptions) username;
      inherit (config.userOptions) wallpaper;
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager.users.${username} = _: {
        stylix.targets.hyprpaper.enable = false;
        services.hyprpaper = {
          enable = true;
          settings = {
            preload = [ "/home/${username}/.config/backgrounds/${wallpaper}" ];
            splash = false;
            wallpaper = [
              {
                monitor = "";
                path = "~/.config/backgrounds/${wallpaper}";
                fit_mode = "cover";
              }
            ];
          };
        };
      };
    };
}
