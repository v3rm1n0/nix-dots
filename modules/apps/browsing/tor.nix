_: {
  flake.modules.nixos.default =
    {
      lib,
      pkgs,
      hostUsernames,
      userProfiles,
      ...
    }:
    let
      users = builtins.filter (n: builtins.elem "browsing-tor" userProfiles.${n}.apps) hostUsernames;
    in
    {
      config = lib.mkMerge (
        [
          (lib.mkIf (users != [ ]) {
            services.tor = {
              enable = true;

              enableGeoIP = false;

              torsocks.enable = true;

              client = {
                enable = true;
              };

              relay = {
                enable = true;
                role = "relay";
              };

              settings = {
                MaxAdvertisedBandwidth = "100 MB";
                BandWidthRate = "50 MB";
                RelayBandwidthRate = "50 MB";
                RelayBandwidthBurst = "100 MB";

                ExitPolicy = "reject *:*";

                CookieAuthentication = true;
                AvoidDiskWrites = 1;
                HardwareAccel = 1;
                SafeLogging = 1;
                NumCPUs = 3;

                ORPort = [ 443 ];
              };
            };

            services.snowflake-proxy = {
              enable = true;
              capacity = 10;
            };
          })
        ]
        ++ map (name: {
          hjem.users.${name}.packages = [ pkgs.tor-browser ];
        }) users
      );
    };
}
