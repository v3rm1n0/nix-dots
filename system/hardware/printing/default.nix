{
  pkgs,
  ...
}:
{
  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.cups-kyocera-ecosys-m552x-p502x ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
