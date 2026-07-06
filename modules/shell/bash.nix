{ self, ... }:
{
  flake.modules.nixos.default =
    {
      config,
      lib,
      ...
    }:
    let
      myAliases = self.lib.commonAliases;
    in
    {
      options.mods.shell.bash.enable = lib.mkEnableOption "Enable bash Module";

      config = lib.mkIf config.mods.shell.bash.enable {
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
