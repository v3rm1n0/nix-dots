_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.mods.security.apparmor.profiles.freetube;
      execPath = "/nix/store/*/bin/" + builtins.baseNameOf (lib.getExe pkgs.freetube);
    in
    {
      options.mods.security.apparmor.profiles.freetube.state = lib.mkOption {
        type = lib.types.enum [
          "disable"
          "complain"
          "enforce"
        ];
        default = "complain";
        description = "Enforcement state of the FreeTube AppArmor profile.";
      };

      config = lib.mkIf (config.mods.security.apparmor.enable && config.mods.apps.media.enable) {
        security.apparmor.policies.freetube = {
          inherit (cfg) state;
          profile = ''
            abi <abi/4.0>,
            include <tunables/global>

            profile freetube ${execPath} flags=(attach_disconnected) {
              include <abstractions/desktop-app>
              include <abstractions/user-download>

              userns,
              ${execPath} mrix,

              owner @{HOME}/.config/FreeTube/{,**} rwk,
              owner @{HOME}/.cache/FreeTube/{,**} rwk,

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
