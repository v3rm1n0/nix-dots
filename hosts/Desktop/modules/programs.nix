{ pkgs, ... }:
{
  config.programs = {
    browsing = {
      chromium = {
        enable = true;
        package = pkgs.brave;
      };
      firefox = {
        enable = true;
        package = pkgs.librewolf;
      };
    };
    dev.optionalPackages = [
      pkgs.zed-editor
    ];
  };
}
