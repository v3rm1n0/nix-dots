_: {
  flake.nixosModules.coreBootKernel = {
    boot.kernelParams = [
      "psmouse.synaptics_intertouch=0"
      "quiet"
      "nowatchdog"
      "nmi_watchdog=0"
    ];
  };
}
