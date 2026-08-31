_: {
  flake.modules.nixos.default =
    {
      lib,
      pkgs,
      hostUsernames,
      ...
    }:
    {
      config = lib.mkMerge (
        map (username: {
          hjem.users.${username}.systemd.services.nm-applet = {
            description = "Network Manager Applet";
            after = [ "graphical-session.target" ];
            partOf = [ "graphical-session.target" ];
            wantedBy = [ "graphical-session.target" ];
            serviceConfig = {
              ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
              Restart = "on-failure";
            };
          };
        }) hostUsernames
      );
    };
}
