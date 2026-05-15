{ self, ... }:
{
  flake.nixosModules.modulesShellFish =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.shell.fish.enable = lib.mkEnableOption "Enable fish Module";

      config = lib.mkIf config.shell.fish.enable {
        programs.fish = {
          enable = true;
          package = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;
        };
      };
    };
}
