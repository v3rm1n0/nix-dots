{ self, inputs, ... }:
{
  flake.nixosModules.hostCommon = {
    imports = [
      self.nixosModules.hostCommonModules
      self.nixosModules.hostCommonEnvironment
      self.nixosModules.hostCommonLocale
    ];
  };
}
