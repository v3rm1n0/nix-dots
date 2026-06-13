{ self, ... }:
{
  flake.nixosModules.modulesShellBash =
    {
      config,
      lib,
      ...
    }:
    let
      myAliases = self.lib.commonAliases;
    in
    {
      options.shell.bash.enable = lib.mkEnableOption "Enable bash Module";

      config = lib.mkIf config.shell.bash.enable {
        programs.bash = {
          completion.enable = true;
          shellAliases = myAliases;
          interactiveShellInit = ''
            eval "$(zoxide init --cmd cd bash)"
          '';
        };
      };
    };
}
