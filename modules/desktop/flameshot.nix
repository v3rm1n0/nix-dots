_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
      inherit (config.lib.stylix) colors;
    in
    {
      options.mods.desktop.flameshot.enable = lib.mkEnableOption "the flameshot screenshot tool";

      config = lib.mkIf config.mods.desktop.flameshot.enable {
        hjem.users.${username}.rum.programs.flameshot = {
          enable = true;
          # wlr support builds in grim-style capture, required on Hyprland.
          package = pkgs.flameshot.override { enableWlrSupport = true; };
          settings.General = {
            savePath = "/home/${username}/Pictures";
            savePathFixed = true;
            filenamePattern = "%Y%m%d_%H%M%S";
            showDesktopNotification = false;
            showStartupLaunchMessage = false;
            disabledTrayIcon = true;
            uiColor = "#${colors.base0D}";
            contrastUiColor = "#${colors.base00}";
          };
        };
      };
    };
}
