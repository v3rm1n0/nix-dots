_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.mods.security.apparmor.profiles.firefox;
      fcfg = config.mods.apps.browsing.firefox;
      pkg = if fcfg.package != null then fcfg.package else pkgs.firefox;
      execPath = "/nix/store/*/bin/" + builtins.baseNameOf (lib.getExe pkg);
    in
    {
      options.mods.security.apparmor.profiles.firefox.state = lib.mkOption {
        type = lib.types.enum [
          "disable"
          "complain"
          "enforce"
        ];
        default = "complain";
        description = "Enforcement state of the Firefox AppArmor profile.";
      };

      config = lib.mkIf (config.mods.security.apparmor.enable && fcfg.enable) {
        security.apparmor.policies.firefox = {
          inherit (cfg) state;
          profile = ''
            abi <abi/4.0>,
            include <tunables/global>

            profile firefox ${execPath} flags=(attach_disconnected) {
              include <abstractions/desktop-app>
              include <abstractions/user-download>

              ${execPath} mrix,

              owner @{HOME}/.mozilla/{,**} rwk,
              owner @{HOME}/.cache/mozilla/{,**} rwk,

              network inet stream,
              network inet6 stream,
              network inet dgram,
              network inet6 dgram,

              /dev/video* rw,
              owner /dev/shm/org.mozilla.*/ rw,
              owner /dev/shm/org.mozilla.*/* rw,
            }
          '';
        };
      };
    };
}
