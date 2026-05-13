_: {
  flake.nixosModules.coreProgramsUtilsRclone =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
      mountdir = "/home/${username}/ProtonDrive";
    in
    {
      environment.systemPackages = [ pkgs.rclone ];
      environment.etc."fuse.conf".text = ''
        user_allow_other
      '';

      hjem.users.${username}.systemd.services.protondrive = {
        description = "Mount Proton Drive";
        after = [ "network-online.target" ];
        wantedBy = [ "default.target" ];
        unitConfig.Type = "notify";
        serviceConfig = {
          Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
          ExecStartPre = "${lib.getExe' pkgs.uutils-coreutils-noprefix "mkdir"} -p ${mountdir}";
          ExecStart = ''
            ${lib.getExe pkgs.rclone} mount proton: ${mountdir} \
              --config=/home/${username}/.config/rclone/rclone.conf \
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
    };
}
