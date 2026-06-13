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
        };
      };
    };
}
