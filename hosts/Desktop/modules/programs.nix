{ pkgs, ... }:
{
  config.programs = {
    dev.optionalPackages = [
        pkgs.zed-editor
      ];
  };
}
