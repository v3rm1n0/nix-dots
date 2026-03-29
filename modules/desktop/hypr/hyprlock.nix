{ inputs, ... }:
{
  flake.nixosModules.modulesDesktopHyprHyprlock =
    { config, ... }:
    let
      username = config.userOptions.username;
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager.users.${username} = {
        programs.hyprlock = {
          enable = true;
        };
      };
    };
}
