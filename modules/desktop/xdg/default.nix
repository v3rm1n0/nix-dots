_: {
  flake.nixosModules.modulesDesktopXdg =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
      librewolf =
        let
          pkg = config.programs.browsing.firefox.package;
        in
        pkg != null && lib.hasPrefix "librewolf" (pkg.pname or pkg.name or "");
      chromium = config.programs.browsing.chromium.enable;
    in
    {
      xdg = {
        mime.defaultApplications = {
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

        portal = {
          enable = true;
          xdgOpenUsePortal = true;
          config.common = {
            default = [
              "xdph"
              "gtk"
            ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
            "org.freedesktop.impl.portal.FileChooser" = [ "gnome" ];
          };
          extraPortals = with pkgs; [
            xdg-desktop-portal
            xdg-desktop-portal-gtk
            xdg-desktop-portal-hyprland
          ];
        };
      };

      hjem.users.${username}.files.".config/user-dirs.dirs".text = ''
        XDG_DESKTOP_DIR="$HOME/Desktop"
        XDG_DOWNLOAD_DIR="$HOME/Downloads"
        XDG_TEMPLATES_DIR="$HOME/Templates"
        XDG_PUBLICSHARE_DIR="$HOME/Public"
        XDG_DOCUMENTS_DIR="$HOME/Documents"
        XDG_MUSIC_DIR="$HOME/Music"
        XDG_PICTURES_DIR="$HOME/Pictures"
        XDG_VIDEOS_DIR="$HOME/Videos"
      '';
    };
}
