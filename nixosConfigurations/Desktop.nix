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
    (
      { pkgs, ... }:
      {
        specs = {
          gpu.enable = true;
          gpu.brand = "nvidia";
        };
        devTools.enable = true;
        devTools.optionalPackages = [
          pkgs.zed-editor
        ];
        gaming.enable = true;
        contentcreation.enable = false;
      }
    )
  ];
}
