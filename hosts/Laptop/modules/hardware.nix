{ ... }:
{
  flake.nixosModules.hostLaptopModulesHardware = {
    config.hardwareModule = {
      gpu.enable = true;
      gpu.brand = "intel";
    };
  };
}
