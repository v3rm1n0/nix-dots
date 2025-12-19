{
  config,
  lib,
  pkgs,
  ...
}:
let
  username = config.userOptions.username;
in
{
  environment.systemPackages = with pkgs; [ rclone ];

  home-manager.users.${username} = {
    systemd.user.services = {
      protondrive =
        let
          mountdir = "/home/${username}/\"ProtonDrive\"";
        in
        {
          Unit = {
            Description = "Mount Proton Drive";
            After = [ "network-online.target" ];
          };

          Service = {
            Type = "notify";
            Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
            ExecStartPre = "${lib.getExe' pkgs.uutils-coreutils-noprefix "mkdir"} -p ${mountdir}";

            ExecStart = ''
              ${lib.getExe pkgs.rclone} mount proton: ${mountdir} \
                --config=/home/${username}/.config/rclone/rclone.conf \
                --vfs-cache-mode full \
                --vfs-cache-max-age 1m \
                --dir-cache-time 30s \
                --poll-interval 15s \
            '';

            ExecStop = "${lib.getExe' pkgs.fuse "fusermount"} -u ${mountdir}";
            Restart = "always";
            RestartSec = 5;
          };

          Install.WantedBy = [ "default.target" ];
        };
    };
  };
  environment.etc."fuse.conf".text = ''
    user_allow_other
  '';
}
