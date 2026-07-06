{ self, ... }:
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

      options.mods.apps.comms.enable = lib.mkEnableOption "Enables communication module";

      config = lib.mkIf config.mods.apps.comms.enable {
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
        };
      };
    };
}
