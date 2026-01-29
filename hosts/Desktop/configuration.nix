{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.Desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.baseLocale

      self.nixosModules.hostDesktop
    ];
  };

  flake.nixosModules.hostDesktop =
    { pkgs, ... }:
    {
      boot.initrd = {
        availableKernelModules = [
          "usb_storage"
        ];
        systemd.enable = true;
      };

      boot.kernelPackages = pkgs.linuxPackages_zen;

      boot.kernelPatches = [
        {
          name = "fix-nova-dependency";
          patch = null;
          extraConfig = ''
            RUST_FW_LOADER_ABSTRACTIONS y
          '';
        }
      ];
    };
}
