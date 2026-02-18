{
  helium,
  lib,
  nix-citizen,
  pkgs,
  system,
  ...
}:
{
  config.programs = {
    ai.enable = true;
    browsing = {
      chromium = {
        enable = false;
        package = helium.packages.${system}.default;
      };
      firefox = {
        enable = true;
        package = pkgs.librewolf;
      };
    };
    content.enable = lib.mkForce true;
    dev.optionalPackages = [
      pkgs.zed-editor
    ];
    gaming.optionalPackages = [
      nix-citizen.packages.${system}.rsi-launcher
      pkgs.stoat-desktop
    ];
  };
}
