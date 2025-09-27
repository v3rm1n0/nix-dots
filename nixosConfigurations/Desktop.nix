{ inputs, system, ... }:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {
    desktopEnvironment = "hyprland";
    displayManager = "greetd";
    hostName = "Desktop";
    systemType = "desktop";
    username = "v3rm1n";
    wallpaper = "gruvbox-nix.png";
    inherit system;
  }
  // inputs;
  modules = [
    ../.
  ];
}
