_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
      home = "/home/${username}";

      mkMount =
        {
          description,
          remote,
          mountdir,
        }:
        {
          inherit description;
          after = [ "network-online.target" ];
          wantedBy = [ "default.target" ];
          unitConfig.Type = "notify";
          serviceConfig = {
            Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
            ExecStartPre = "${lib.getExe' pkgs.uutils-coreutils-noprefix "mkdir"} -p ${mountdir}";
            ExecStart = ''
              ${lib.getExe pkgs.rclone} mount ${remote}: ${mountdir} \
                --config=${home}/.config/rclone/rclone.conf \
                --vfs-cache-mode full \
                --vfs-cache-max-age 1m \
                --dir-cache-time 30s \
                --poll-interval 15s
            '';
            ExecStop = "${lib.getExe' pkgs.fuse "fusermount"} -u ${mountdir}";
            Restart = "always";
            RestartSec = 5;
          };
        };
    in
    {
      environment.systemPackages = [ pkgs.rclone ];
      environment.etc."fuse.conf".text = ''
        user_allow_other
      '';

      hjem.users.${username}.systemd.services = {
        protondrive = mkMount {
          description = "Mount Proton Drive";
          remote = "proton";
          mountdir = "${home}/ProtonDrive";
        };
        iclouddrive =
          lib.recursiveUpdate
            (mkMount {
              description = "Mount iCloud Drive";
              remote = "icloud";
              mountdir = "${home}/iCloudDrive";
            })
            {
              serviceConfig.ExecStartPost = ''
                -${lib.getExe pkgs.rclone} bisync icloud:KeePassium ${home}/KeePass \
                  --config=${home}/.config/rclone/rclone.conf \
                  --resilient \
                  --conflict-resolve newer
              '';
            };
      };
    };
}
