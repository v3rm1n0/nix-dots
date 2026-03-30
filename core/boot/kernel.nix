{ ... }:
{
  flake.nixosModules.coreBootKernel = {
    boot.kernelParams = [
      "psmouse.synaptics_intertouch=0"
      "quiet"
    ];
  };
}
