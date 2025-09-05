{ inputs, system, ... }:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {
    desktopEnvironment = "hyprland";
    displayManager = "sddm";
    hostName = "Laptop";
    systemType = "desktop";
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
          gpu.brand = "nvidia";
          boot.isDevDrive = false;
        };
        devTools.enable = true;
        gaming.enable = true;
      }
    )
  ];
}
