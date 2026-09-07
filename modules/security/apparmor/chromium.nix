_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.mods.security.apparmor.profiles.chromium;
      ccfg = config.mods.apps.browsing.chromium;
      execPath = "/nix/store/*/bin/" + builtins.baseNameOf (lib.getExe ccfg.package);
    in
    {
      options.mods.security.apparmor.profiles.chromium.state = lib.mkOption {
        type = lib.types.enum [
          "disable"
          "complain"
          "enforce"
        ];
        default = "complain";
        description = "Enforcement state of the Chromium/Helium AppArmor profile.";
      };

      config = lib.mkIf (config.mods.security.apparmor.enable && ccfg.enable && ccfg.package != null) {
        security.apparmor.policies.chromium = {
          inherit (cfg) state;
          profile = ''
            abi <abi/4.0>,
            include <tunables/global>

            profile chromium ${execPath} flags=(attach_disconnected) {
              include <abstractions/desktop-app>
              include <abstractions/user-download>

              userns,
              ${execPath} mrix,

              owner @{HOME}/.config/{chromium,google-chrome,net.imput.helium,BraveSoftware/Brave-Browser}/{,**} rwk,
              owner @{HOME}/.cache/{chromium,google-chrome,net.imput.helium,BraveSoftware/Brave-Browser}/{,**} rwk,

              network inet stream,
              network inet6 stream,
              network inet dgram,
              network inet6 dgram,

              /dev/video* rw,
              owner /dev/shm/{,.}org.chromium.*/ rw,
              owner /dev/shm/{,.}org.chromium.*/* rw,
            }
          '';
        };
      };
    };
}
