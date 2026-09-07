_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.mods.security.apparmor.profiles.tor-browser;
      tcfg = config.mods.apps.browsing.tor;
      execPath = "/nix/store/*/bin/" + builtins.baseNameOf (lib.getExe pkgs.tor-browser);
    in
    {
      options.mods.security.apparmor.profiles.tor-browser.state = lib.mkOption {
        type = lib.types.enum [
          "disable"
          "complain"
          "enforce"
        ];
        default = "complain";
        description = "Enforcement state of the Tor Browser AppArmor profile.";
      };

      config = lib.mkIf (config.mods.security.apparmor.enable && tcfg.enable) {
        security.apparmor.policies.tor-browser = {
          inherit (cfg) state;
          profile = ''
            abi <abi/4.0>,
            include <tunables/global>

            profile tor-browser ${execPath} flags=(attach_disconnected) {
              include <abstractions/desktop-app>
              include <abstractions/user-download>

              ${execPath} mrix,

              owner @{HOME}/.local/share/torbrowser/{,**} rwk,
              owner @{HOME}/.cache/torbrowser/{,**} rwk,

              network inet stream,
              network inet6 stream,
              network inet dgram,
              network inet6 dgram,

              owner /dev/shm/org.mozilla.*/ rw,
              owner /dev/shm/org.mozilla.*/* rw,
            }
          '';
        };
      };
    };
}
