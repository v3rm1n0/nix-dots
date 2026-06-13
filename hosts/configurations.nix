{ self, inputs, ... }:
let
  # Each host shares the same module spine and differs only by its
  # host-specific hardware/hardware-specific/modules trio, which follow
  # the `host<Name><Role>` naming convention.
  mkHost =
    name:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        self.nixosModules.assets
        self.nixosModules.users
        self.nixosModules.core
        self.nixosModules.modules
        self.nixosModules.hostCommon
        self.nixosModules."host${name}Hardware"
        self.nixosModules."host${name}HardwareSpecific"
        self.nixosModules."host${name}Modules"
      ];
    };
in
{
  flake.nixosConfigurations = {
    Desktop = mkHost "Desktop";
    Laptop = mkHost "Laptop";
  };
}
