_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.mods.apps.uni = {
        enable = lib.mkEnableOption "Enable uni module aka tex shit";
      };

      config = lib.mkIf config.mods.apps.uni.enable {
        environment.systemPackages = with pkgs; [
          texliveFull
        ];
      };
    };
}
