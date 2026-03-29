{ ... }:
{
  flake.nixosModules.hostLaptopHardwareSpecific =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_zen;
    };
}
