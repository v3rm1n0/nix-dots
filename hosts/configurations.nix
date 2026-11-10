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
    # Template is a scaffold to copy, not a buildable host: it has no hardware
    # configuration and leaves required userOptions unset, so instantiating it
    # here would make `nix flake check` fail. Register it once it's fleshed out.
  };
}
