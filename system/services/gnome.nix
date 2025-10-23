{ config, lib, ... }:
{
  services.gnome.gnome-keyring = {
    enable = true;
  };
}
