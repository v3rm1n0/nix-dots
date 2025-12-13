{ helium, pkgs, system, ... }:
{
  config.programs = {
    browsing = {
      chromium = {
        enable = true;
        package = helium.defaultPackage.${system};
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
