_: {
  flake.nixosModules.coreServicesNmapplet =
    { config, pkgs, ... }:
    let
      inherit (config.userOptions) username;
    in
    {
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
    };
}
