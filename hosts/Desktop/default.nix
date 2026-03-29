{ self, inputs, ... }:
{
  flake.nixosConfigurations.Desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.assets

      self.nixosModules.usersV3rm1n

      self.nixosModules.core
      self.nixosModules.modules

      self.nixosModules.hostCommon
      self.nixosModules.hostDesktopHardware
      self.nixosModules.hostDesktopHardwareSpecific
      self.nixosModules.hostDesktopModules
    ];
  };
}
