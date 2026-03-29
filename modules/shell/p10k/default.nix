{ inputs, ... }:
{
  flake.nixosModules.modulesShellP10k =
    { config, ... }:
    let
      username = config.userOptions.username;
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager.users.${username} = _: {
        home.file = {
          ".config/zsh/.p10k.zsh".source = ./p10k.zsh;
        };
      };
    };
}
