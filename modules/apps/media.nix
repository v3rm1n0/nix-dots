{ inputs, ... }:
{
  flake.modules.nixos.default =
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

      options.mods.apps.media.enable = lib.mkEnableOption "Enables media module";

      config = lib.mkIf config.mods.apps.media.enable {
        programs.spicetify.enable = true;

        hjem.users.${username} = {
          packages = with pkgs; [
            freetube
            librepods
            jellyfin-mpv-shim
            vlc
          ];
          rum.programs.mpv = {
            enable = true;
            config = {
              fullscreen = true;
              ytdl-format = "bestvideo+bestaudio/best";
            };
            scripts = with pkgs.mpvScripts; [
              modernz
              sponsorblock-minimal
              thumbfast
            ];
          };
        };
      };
    };
}
