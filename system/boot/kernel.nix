{ config, lib, ... }:
{
  boot.kernelParams = [
    "psmouse.synaptics_intertouch=0"
    "quiet"
  ];
}
