{ self, inputs, ... }:
let
  mkHost =
    name:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        self.modules.nixos.default
        self.modules.nixos."host/${name}"
      ];
    };
in
{
  flake.nixosConfigurations = {
    Desktop = mkHost "Desktop";
    Laptop = mkHost "Laptop";
    Template = mkHost "Template";
  };
}
