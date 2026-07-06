{ self, inputs, ... }:
let
  mkHost =
    name:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        self.modules.nixos.default
        self.modules.nixos."host/${name}"
        # Legacy aggregates, emptied out area by area during the migration.
        self.nixosModules.assets
        self.nixosModules.users
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
