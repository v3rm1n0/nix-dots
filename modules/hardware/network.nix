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

  users.users.${username} = {
    extraGroups = [ "networkmanager" ];
  };

  programs.traceroute.enable = true;
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
