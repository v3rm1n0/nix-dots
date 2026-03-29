{ self, inputs, ... }:
{
  flake.nixosModules.modulesShellBash =
    let
      myAliases = self.lib.commonAliases;
    in
    {
      programs.bash = {
        completion.enable = true;
        shellAliases = myAliases;
        interactiveShellInit = ''
          eval "$(zoxide init --cmd cd bash)"
        '';
      };
    };
}
