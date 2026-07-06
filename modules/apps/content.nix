_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      defaultPackages = [ ];
    in
    {
      options.mods.apps.content = {
        enable = lib.mkEnableOption "Enable content creation tools";

        optionalPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          example = [
            pkgs.davinci-resolve-studio
          ];
          description = "List of optional packages to install alongside the default ones.";
        };
      };

      config = lib.mkIf config.mods.apps.content.enable {
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
