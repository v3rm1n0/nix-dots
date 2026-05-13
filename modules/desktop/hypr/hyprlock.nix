_: {
  flake.nixosModules.modulesDesktopHyprHyprlock =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.hyprlock ];
    };
}
