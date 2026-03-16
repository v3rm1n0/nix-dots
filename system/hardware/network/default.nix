{
  config,
  lib,
  ...
}:
let
  username = config.userOptions.username;
in
{
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager = {
      dns = "systemd-resolved";
      enable = true;
      wifi.powersave = true;
    };
    hostName = config.userOptions.hostName;
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
          "9.9.9.11"
          "149.112.112.11"
        ];
      };
    };
  };

  users.users.${username} = {
    extraGroups = [ "networkmanager" ];
  };

  programs.traceroute.enable = true;

  # services.i2pd = {
  #   enable = true;
  #   address = "127.0.0.1";
  #   proto = {
  #     http.enable = true;
  #     httpProxy.enable = true;
  #     socksProxy.enable = true;
  #     sam.enable = true;
  #     i2cp = {
  #       enable = true;
  #       address = "127.0.0.1";
  #       port = 7654;
  #     };
  #   };
  # };
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
