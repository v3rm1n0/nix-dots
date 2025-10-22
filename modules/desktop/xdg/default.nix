{
  config,
  pkgs,
  ...
}:
let
  username = config.userOptions.username;
in
{
  xdg = {
    mime = {
      # TODO: Check wether the librewolf entries are still required in the future
      defaultApplications = {
        "application/pdf" = [ "zathura.desktop" ];
        "application/x-gnome-saved-search" = [ "nemo.desktop" ];
        "image/jpeg" = [ "gthumb.desktop" ];
        "image/jpg" = [ "gthumb.desktop" ];
        "image/png" = [ "gthumb.desktop" ];
        "inode/directory" = [ "nemo.desktop" ];
        "text/html" = [ "librewolf.desktop" ];
        "video/avi" = [ "vlc.desktop" ];
        "video/mp4" = [ "vlc.desktop" ];
        "video/x-matroska" = [ "vlc.desktop" ];
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
            "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
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
