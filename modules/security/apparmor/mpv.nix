_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.mods.security.apparmor.profiles.mpv;
      execPath = "/nix/store/*/bin/" + builtins.baseNameOf (lib.getExe pkgs.mpv);
    in
    {
      options.mods.security.apparmor.profiles.mpv.state = lib.mkOption {
        type = lib.types.enum [
          "disable"
          "complain"
          "enforce"
        ];
        default = "complain";
        description = "Enforcement state of the mpv AppArmor profile.";
      };

      config = lib.mkIf (config.mods.security.apparmor.enable && config.mods.apps.media.enable) {
        security.apparmor.policies.mpv = {
          inherit (cfg) state;
          profile = ''
            abi <abi/4.0>,
            include <tunables/global>

            profile mpv ${execPath} flags=(attach_disconnected) {
              include <abstractions/desktop-app>

              ${execPath} mrix,

              owner @{HOME}/.config/mpv/{,**} rwk,
              owner @{HOME}/.cache/mpv/{,**} rwk,

              owner @{HOME}/ r,
              owner @{HOME}/** r,
              /run/media/**  r,
              /media/**      r,
              /mnt/**        r,

              network inet stream,
              network inet6 stream,
              network inet dgram,
              network inet6 dgram,
            }
          '';
        };
      };
    };
}
