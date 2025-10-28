{ pkgs, ... }:
{
  config.programs = {
    browsing = {
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
