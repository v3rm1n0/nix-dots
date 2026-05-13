{ self, ... }:
{
  flake.nixosModules.applicationsComms =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
    in
    {
      imports = [ self.nixosModules.applicationsCommsDiscord ];

      options.programs.comms.enable = lib.mkEnableOption "Enables communication module";

      config = lib.mkIf config.programs.comms.enable {
        hjem.users.${username} = {
          packages = with pkgs; [
            cinny-desktop
            gajim
            mumble
            protonmail-desktop
            signal-desktop
            teamspeak6-client
            zoom-us
          ];

          files.".local/share/applications/proton-mail.desktop".text = ''
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
