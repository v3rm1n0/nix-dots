{ inputs, system, ... }:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {
    hostName = "Laptop";
    username = "v3rm1n";
    wallpaper = "gruvbox-nix.png";
    inherit system;
  }
  // inputs;
  modules = [
    ../.
    (
      { ... }:
      {
        specs = {
          gpu.enable = true;
          gpu.brand = "intel";
        };
        devTools.enable = true;
        gaming.enable = true;
      }
    )
  ];
}
