_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.mods.security.apparmor.profiles.zoom;
      execPath = "/nix/store/*/bin/" + builtins.baseNameOf (lib.getExe pkgs.zoom-us);
    in
    {
      options.mods.security.apparmor.profiles.zoom.state = lib.mkOption {
        type = lib.types.enum [
          "disable"
          "complain"
          "enforce"
        ];
        default = "complain";
        description = "Enforcement state of the Zoom AppArmor profile.";
      };

      config = lib.mkIf (config.mods.security.apparmor.enable && config.mods.apps.comms.enable) {
        security.apparmor.policies.zoom = {
          inherit (cfg) state;
          profile = ''
            abi <abi/4.0>,
            include <tunables/global>

            profile zoom ${execPath} flags=(attach_disconnected) {
              include <abstractions/desktop-app>
              include <abstractions/user-download>

              userns,
              ${execPath} mrix,

              owner @{HOME}/.zoom/{,**} rwk,
              owner @{HOME}/.config/zoomus.conf rwk,
              owner @{HOME}/.cache/zoom/{,**} rwk,

              network inet stream,
              network inet6 stream,
              network inet dgram,
              network inet6 dgram,

              /dev/video* rw,
            }
          '';
        };
      };
    };
}
