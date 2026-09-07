_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.mods.security.apparmor.profiles.vlc;
      execPath = "/nix/store/*/bin/" + builtins.baseNameOf (lib.getExe pkgs.vlc);
    in
    {
      options.mods.security.apparmor.profiles.vlc.state = lib.mkOption {
        type = lib.types.enum [
          "disable"
          "complain"
          "enforce"
        ];
        default = "complain";
        description = "Enforcement state of the VLC AppArmor profile.";
      };

      config = lib.mkIf (config.mods.security.apparmor.enable && config.mods.apps.media.enable) {
        security.apparmor.policies.vlc = {
          inherit (cfg) state;
          profile = ''
            abi <abi/4.0>,
            include <tunables/global>

            profile vlc ${execPath} flags=(attach_disconnected) {
              include <abstractions/desktop-app>

              ${execPath} mrix,

              owner @{HOME}/.config/vlc/{,**} rwk,
              owner @{HOME}/.cache/vlc/{,**} rwk,
              owner @{HOME}/.local/share/vlc/{,**} rwk,

              owner @{HOME}/ r,
              owner @{HOME}/** r,
              /run/media/**  r,
              /media/**      r,
              /mnt/**        r,

              network inet stream,
              network inet6 stream,
              network inet dgram,
              network inet6 dgram,

              /dev/dvd r,
              /dev/sr[0-9]* r,
            }
          '';
        };
      };
    };
}
