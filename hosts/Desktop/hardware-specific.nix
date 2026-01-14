{ pkgs, ... }:
{
  boot.initrd = {
    availableKernelModules = [
      "usb_storage"
    ];
    systemd.enable = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;
}
