{ inputs, ... }:
{
  flake.nixosModules.applicationsMedia =
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
      imports = [ inputs.spicetify-nix.nixosModules.default ];

      options.programs.media.enable = lib.mkEnableOption "Enables media module";

      config = lib.mkIf config.programs.media.enable {
        programs.spicetify.enable = true;

        environment.systemPackages = [ pkgs.mpv ];

        hjem.users.${username} = {
          packages = with pkgs; [
            freetube
            librepods
            vlc
            mpvScripts.modernz
            mpvScripts.sponsorblock-minimal
            mpvScripts.thumbfast
          ];

          files.".config/mpv/mpv.conf".text = ''
            fullscreen=yes
            ytdl-format=bestvideo+bestaudio/best
            script=${pkgs.mpvScripts.modernz}/share/mpv/scripts/modernz.lua
            script=${pkgs.mpvScripts.sponsorblock-minimal}/share/mpv/scripts/sponsorblock_minimal.lua
            script=${pkgs.mpvScripts.thumbfast}/share/mpv/scripts/thumbfast.lua
          '';
        };
      };
    };
}
