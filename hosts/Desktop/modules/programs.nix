{
  lib,
  pkgs,
  system,
  ...
}:
{
  config.programs = {
    ai.enable = true;
    browsing = {
      chromium = {
        enable = true;
        package = pkgs.brave;
      };
      firefox = {
        enable = false;
        package = pkgs.librewolf;
      };
    };
    content.enable = lib.mkForce true;
    dev.optionalPackages = [
      pkgs.zed-editor
    ];
    gaming.optionalPackages = [
      pkgs.stoat-desktop
    ];
  };
}
