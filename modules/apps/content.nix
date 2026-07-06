_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    with lib;

    let
      defaultPackages = with pkgs; [ ];
    in
    {
      options.mods.apps.content = {
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

      config = mkIf config.mods.apps.content.enable {
        environment.systemPackages = defaultPackages ++ config.mods.apps.content.optionalPackages;

        programs.obs-studio = {
          enable = true;
          package = pkgs.obs-studio.override { cudaSupport = true; };
          plugins = with pkgs.obs-studio-plugins; [
            wlrobs
            obs-vaapi
            obs-vkcapture
            obs-pipewire-audio-capture
          ];
        };
      };
    };
}
