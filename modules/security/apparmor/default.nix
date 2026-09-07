_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.mods.security.apparmor;
    in
    {
      options.mods.security.apparmor = {
        enable = lib.mkEnableOption "AppArmor mandatory access control with per-app confinement profiles";

        killUnconfinedConfinables = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Send SIGTERM to already-running processes that gain a profile on policy reload.
            Disabled by default because a `nixos-rebuild switch` would otherwise kill live
            sessions of any newly-confined app (browsers, chat clients, ...).
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        security.apparmor = {
          enable = true;
          killUnconfinedConfinables = cfg.killUnconfinedConfinables;

          includes."abstractions/desktop-app" = ''
            include <abstractions/base>
            include <abstractions/nameservice>
            include <abstractions/fonts>
            include <abstractions/freedesktop.org>
            include <abstractions/audio>
            include <abstractions/dbus-session>
            include <abstractions/wayland>
            include <abstractions/user-tmp>

            /etc/nsswitch.conf r,
            /etc/ssl/certs/ r,
            /etc/ssl/certs/** r,
            /etc/machine-id r,
            /etc/os-release r,
            /etc/nixos/** r,

            /nix/store/ r,
            /nix/store/** r,
            /nix/store/*/bin/** mrix,
            /nix/store/*/libexec/** mrix,

            owner @{HOME}/.cache/mesa_shader_cache*/{,**} rw,
            owner @{HOME}/.config/dconf/user r,
            owner @{HOME}/.config/gtk-3.0/settings.ini r,
            owner @{HOME}/.config/gtk-4.0/settings.ini r,
            owner @{HOME}/.local/share/icons/{,**} r,

            owner @{run}/user/[0-9]*/ r,
            owner @{run}/user/[0-9]*/pipewire-0 rw,
            owner @{run}/user/[0-9]*/pulse/native rw,
            owner @{run}/user/[0-9]*/bus rw,
            owner @{run}/user/[0-9]*/at-spi/bus rw,

            /dev/dri/ r,
            /dev/dri/card* rw,
            /dev/dri/renderD* rw,

            @{sys}/devices/system/cpu/{,**} r,

            signal (receive) peer=unconfined,
          '';
        };
      };
    };
}
