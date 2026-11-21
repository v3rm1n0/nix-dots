_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (config.userOptions) username;
    in
    {
      networking = {
        useDHCP = lib.mkDefault true;
        nftables.enable = true;
        networkmanager = {
          dns = lib.mkIf config.services.resolved.enable "systemd-resolved";
          enable = true;
          wifi.powersave = true;
          settings.connection = {
            "ipv4.ignore-auto-dns" = true;
            "ipv6.ignore-auto-dns" = true;
            "connection.llmnr" = 0;
            "connection.mdns" = 0;
          };
        };
        inherit (config.userOptions) hostName;
        firewall = {
          allowedTCPPorts = [
            53317 # localsend
          ];
          allowedUDPPorts = [
            53317 # localsend
          ];
        };
      };

      services.resolved = {
        enable = true;
        settings = {
          Resolve = {
            DNSSEC = true;
            DNSOverTLS = true;
            DNS = [
              "1.1.1.1"
            ];
            Domains = [ "~." ];
            FallbackDNS = "";
            LLMNR = false;
            MulticastDNS = false;
          };
        };
      };

      users.users.${username} = {
        extraGroups = [ "networkmanager" ];
      };

      programs.traceroute.enable = true;
    };
}

/*
  Open TCP port:
   nixos-firewall-tool open tcp 8888

  Show all firewall rules:
   nixos-firewall-tool show

  Open UDP port:
   nixos-firewall-tool open udp 51820

  Reset firewall configuration to system settings:
   nixos-firewall-tool reset
*/
