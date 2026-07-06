{
  flake.modules.nixos.default =
    { config, lib, ... }:
    {
      options.mods.desktop.ly.enable = lib.mkEnableOption "the ly display manager";

      config = lib.mkIf config.mods.desktop.ly.enable {
        services.displayManager.ly = {
          enable = true;
          settings = {
            bigclock = "en";
            save = true;
            setup_cmd = "";
            vi_mode = true;
          };
        };
      };
    };
}
