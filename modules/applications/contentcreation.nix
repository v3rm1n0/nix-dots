{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  defaultPackages = with pkgs; [
    davinci-resolve
  ];
in
{
  options.programs.content = {
    enable = mkEnableOption "Enable content creation tools";

    optionalPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = [
        pkgs.davinci-resolve-studio
      ];
      description = "List of optional packages to install alongside the default ones.";
    };
  };

  config = mkIf config.programs.content.enable {
    environment.systemPackages = defaultPackages ++ config.programs.content.optionalPackages;

    programs.obs-studio = {
      enable = true;
      package = (pkgs.obs-studio.override { cudaSupport = true; });
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vaapi
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };
  };
}
