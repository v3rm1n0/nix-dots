_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      ...
    }:
    {
      options.mods.apps.tdarr.enable = lib.mkEnableOption "Enable tdarr node";

      config = lib.mkIf config.mods.apps.tdarr.enable {
        fileSystems."/media" = {
          device = "172.16.0.99:/media";
          fsType = "nfs";
          options = [
            "nfsvers=4"
            "soft"
            "timeo=30"
            "x-systemd.automount"
            "noauto"
          ];
        };

        services.tdarr.nodes.desktop = {
          serverURL = "http://172.16.0.115:8266";
          workers.transcodeCPU = 0;
          workers.transcodeGPU = 5;
        };

        systemd.services.tdarr-node-desktop.serviceConfig.ReadWritePaths = [ "/media" ];
        # tdarr's passwd home (/var/lib/tdarr) is read-only under ProtectSystem=strict;
        # pnpm needs a writable $HOME/.local/share/pnpm store, so point it at the
        # writable StateDirectory subtree instead.
        systemd.services.tdarr-node-desktop.environment.HOME = "/var/lib/tdarr/nodes/desktop";
      };
    };
}
