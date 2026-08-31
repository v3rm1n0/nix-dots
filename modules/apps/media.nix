{ inputs, ... }:
{
  flake.modules.nixos.default =
    {
      lib,
      pkgs,
      hostUsernames,
      userProfiles,
      ...
    }:
    let
      users = builtins.filter (n: builtins.elem "media" userProfiles.${n}.apps) hostUsernames;
    in
    {
      imports = [ inputs.spicetify-nix.nixosModules.default ];

      config = lib.mkMerge (
        [
          (lib.mkIf (users != [ ]) { programs.spicetify.enable = true; })
        ]
        ++ map (name: {
          hjem.users.${name} = {
            packages = with pkgs; [
              freetube
              librepods
              jellyfin-mpv-shim
              vlc
            ];
            rum.programs.mpv = {
              enable = true;
              config = {
                border = false;
                fullscreen = false;
                icc-profile-auto = true;
                osc = false;
                target-colorspace-hint = "auto";
                ytdl-format = "bestvideo+bestaudio/best";
              };
              scripts = with pkgs.mpvScripts; [
                modernx
                sponsorblock-minimal
                thumbfast
              ];
            };
          };
        }) users
      );
    };
}
