_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.mods.security.apparmor.profiles.signal-desktop;
      execPath = "/nix/store/*/bin/" + builtins.baseNameOf (lib.getExe pkgs.signal-desktop);
    in
    {
      options.mods.security.apparmor.profiles.signal-desktop.state = lib.mkOption {
        type = lib.types.enum [
          "disable"
          "complain"
          "enforce"
        ];
        default = "complain";
        description = "Enforcement state of the Signal Desktop AppArmor profile.";
      };

      config = lib.mkIf (config.mods.security.apparmor.enable && config.mods.apps.comms.enable) {
        security.apparmor.policies.signal-desktop = {
          inherit (cfg) state;
          profile = ''
            abi <abi/4.0>,
            include <tunables/global>

            profile signal-desktop ${execPath} flags=(attach_disconnected) {
              include <abstractions/desktop-app>
              include <abstractions/user-download>

              userns,
              ${execPath} mrix,

              owner @{HOME}/.config/Signal/{,**} rwk,
              owner @{HOME}/.cache/Signal/{,**} rwk,

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
