_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      hostUsernames,
      ...
    }:
    let
      inherit (config.lib.stylix) colors;
    in
    {
      options.mods.desktop.flameshot.enable = lib.mkEnableOption "the flameshot screenshot tool";

      config = lib.mkIf config.mods.desktop.flameshot.enable (
        lib.mkMerge (
          map (username: {
            hjem.users.${username}.rum.programs.flameshot = {
              enable = true;
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
          }) hostUsernames
        )
      );
    };
}
