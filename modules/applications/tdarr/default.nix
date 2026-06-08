_: {
  flake.nixosModules.applicationsTdarr =
    {
      config,
      lib,
      ...
    }:
    {
      options.programs.tdarr.enable = lib.mkEnableOption "Enable tdarr node";

      config = lib.mkIf config.programs.tdarr.enable {
        nixpkgs.overlays = [
          (final: prev: {
            tdarr-node = prev.tdarr-node.overrideAttrs (_old: {
              version = "2.77.01";
              src =
                let
                  platform =
                    {
                      x86_64-linux = "linux_x64";
                      aarch64-linux = "linux_arm64";
                      x86_64-darwin = "darwin_x64";
                      aarch64-darwin = "darwin_arm64";
                    }
                    .${final.stdenv.hostPlatform.system}
                      or (throw "tdarr-node: unsupported system ${final.stdenv.hostPlatform.system}");
                  hashes = {
                    linux_x64 = "sha256-jdnR9qlw0sN+2IXRuu5wFe9yNXbh3Tfx2XlT6aPw4Pg=";
                  };
                in
                final.fetchzip {
                  url = "https://storage.tdarr.io/versions/2.77.01/${platform}/Tdarr_Node.zip";
                  sha256 = hashes.${platform} or (throw "tdarr-node 2.77.01: no hash for platform ${platform}");
                  stripRoot = false;
                };
            });
          })
        ];

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
          workers.transcodeCPU = 2;
          workers.transcodeGPU = 2;
        };

        systemd.services.tdarr-node-desktop.serviceConfig.ReadWritePaths = [ "/media" ];
      };
    };
}
