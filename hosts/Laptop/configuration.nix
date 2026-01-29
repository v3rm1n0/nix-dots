{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.Laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.baseLocale

      self.nixosModules.hostLaptop
    ];
  };

  flake.nixosModules.hostLaptop =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_zen;
    };
}
