{
  config,
  lib,
  pkgs,
  ...
}:
let
  username = config.userOptions.username;
  librewolf = config.programs.browsing.firefox.package == pkgs.librewolf;
  chromium = config.programs.browsing.chromium.enable;
in
{
  xdg = {
    mime = {
      defaultApplications = {
        "application/pdf" = [ "zathura.desktop" ];
        "application/x-gnome-saved-search" = [ "nautilus.desktop" ];
        "image/jpeg" = [ "gthumb.desktop" ];
        "image/jpg" = [ "gthumb.desktop" ];
        "image/png" = [ "gthumb.desktop" ];
        "inode/directory" = [ "nautilus.desktop" ];
        "video/avi" = [ "vlc.desktop" ];
        "video/mp4" = [ "vlc.desktop" ];
        "video/x-matroska" = [ "vlc.desktop" ];
      }
      // lib.optionalAttrs (librewolf && !chromium) {
        "text/html" = [ "librewolf.desktop" ];
        "x-scheme-handler/http" = [ "librewolf.desktop" ];
        "x-scheme-handler/https" = [ "librewolf.desktop" ];
      };
    };
  };

  home-manager.users.${username} = _: {
    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
      };
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config = {
          common = {
            default = [
              "xdph"
              "gtk"
            ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
            "org.freedesktop.impl.portal.FileChooser" = [ "gnome" ];
          };
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
        ];
      };
    };
  };
}
