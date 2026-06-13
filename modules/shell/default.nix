{ self, ... }:
{
  flake.nixosModules.modulesShell = {
    imports = [
      self.nixosModules.modulesShellBash
      self.nixosModules.modulesShellFish
      self.nixosModules.modulesShellP10k
      self.nixosModules.modulesShellZsh
    ];
  };
}
