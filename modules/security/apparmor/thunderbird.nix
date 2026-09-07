_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.mods.security.apparmor.profiles.thunderbird;
      execPath = "/nix/store/*/bin/" + builtins.baseNameOf (lib.getExe pkgs.thunderbird);
    in
    {
      options.mods.security.apparmor.profiles.thunderbird.state = lib.mkOption {
        type = lib.types.enum [
          "disable"
          "complain"
          "enforce"
        ];
        default = "complain";
        description = "Enforcement state of the Thunderbird AppArmor profile.";
      };

      config = lib.mkIf (config.mods.security.apparmor.enable && config.mods.apps.comms.enable) {
        security.apparmor.policies.thunderbird = {
          inherit (cfg) state;
          profile = ''
            abi <abi/4.0>,
            include <tunables/global>

            profile thunderbird ${execPath} flags=(attach_disconnected) {
              include <abstractions/desktop-app>
              include <abstractions/user-download>

              ${execPath} mrix,

              owner @{HOME}/.thunderbird/{,**} rwk,
              owner @{HOME}/.cache/thunderbird/{,**} rwk,

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
