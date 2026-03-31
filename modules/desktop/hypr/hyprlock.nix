{ inputs, ... }:
{
  flake.nixosModules.modulesDesktopHyprHyprlock =
    { config, ... }:
    let
      inherit (config.userOptions) username;
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
