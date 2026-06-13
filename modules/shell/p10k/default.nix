_: {
  flake.nixosModules.modulesShellP10k =
    { config, lib, ... }:
    let
      inherit (config.userOptions) username;
    in
    {
      config = lib.mkIf config.shell.zsh.enable {
        hjem.users.${username}.files.".config/zsh/.p10k.zsh".source = ./p10k.zsh;
      };
    };
}
