_: {
  flake.modules.nixos."host/Laptop" =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_zen;
    };
}
