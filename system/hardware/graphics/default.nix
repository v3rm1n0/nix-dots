{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkMerge;
  cfg = config.hardwareModule;
in
{
  config = mkMerge [
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    }

    # NVIDIA specifics
    (mkIf (cfg.gpu.enable && cfg.gpu.brand == "nvidia") {
      services.xserver.videoDrivers = [ "nvidia" ];

      boot.kernelModules = [ "nvidia-uvm" ];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    })

    # Intel specifics
    (mkIf (cfg.gpu.enable && cfg.gpu.brand == "intel") {
      hardware.graphics.extraPackages = with pkgs; [
        vpl-gpu-rt
        # intel-media-sdk  # uncomment for older Gen (pre-Xe) iGPUs
      ];
    })
  ];
}
