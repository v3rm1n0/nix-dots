_: {
  flake.nixosModules.modulesShellP10k =
    { config, ... }:
    let
      inherit (config.userOptions) username;
    in
    {
      hjem.users.${username}.files.".config/zsh/.p10k.zsh".source = ./p10k.zsh;
    };
}
