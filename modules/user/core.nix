{ inputs, ... }:
{
  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      imports = [ inputs.hjem.nixosModules.hjem ];

      programs.zsh.enable = true;
      users.mutableUsers = true;
      users.defaultUserShell = pkgs.zsh;

      hjem = {
        extraModules = [
          inputs.hjem-rum.hjemModules.default
        ];
        clobberByDefault = true;
      };
    };
}
