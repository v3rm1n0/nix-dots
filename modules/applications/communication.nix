{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  options.programs.comms = {
    enable = lib.mkEnableOption "Enables communication module";
  };

  config = lib.mkIf config.programs.comms.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        element-desktop
        protonmail-desktop
        signal-desktop
        teamspeak6-client
        whatsapp-for-linux
        zoom-us
        zulip
      ];

      home.file = {
        ".local/share/applications/proton-mail.desktop".text = ''
          [Desktop Entry]
          Name=Proton Mail
          Exec=proton-mail --ozone-platform=x11
          Terminal=false
          Type=Application
          Icon=${pkgs.protonmail-desktop}/share/pixmaps/proton-mail.png
          Categories=Network;Email;
        '';
      };
    };
  };
}
