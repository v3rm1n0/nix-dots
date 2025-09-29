{ inputs, system, ... }:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {
    hostName = "Desktop";
    username = "v3rm1n";
    wallpaper = "gruvbox-nix.png";
    inherit system;
  }
  // inputs;
  modules = [
    ../.
  ];
}
