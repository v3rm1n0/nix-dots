{ pkgs, ... }:
{
  programs = {
    dev.optionalPackages = [
        pkgs.zed-editor
      ];
  };
}
