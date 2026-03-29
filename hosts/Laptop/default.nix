{ self, inputs, ... }:
{
  flake.nixosConfigurations.Laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.assets

      self.nixosModules.usersV3rm1n

      self.nixosModules.core
      self.nixosModules.modules

      self.nixosModules.hostCommon
      self.nixosModules.hostLaptopHardware
      self.nixosModules.hostLaptopHardwareSpecific
      self.nixosModules.hostLaptopModules
    ];
  };
}
