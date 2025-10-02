{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.uni = {
    enable = lib.mkEnableOption "Enable uni module aka tex shit";
  };

  config = lib.mkIf config.programs.uni.enable {
    environment.systemPackages = with pkgs; [
      texliveFull
    ];
  };
}
