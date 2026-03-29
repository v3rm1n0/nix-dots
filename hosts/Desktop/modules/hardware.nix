{ self, inputs, ... }:
{
  flake.nixosModules.hostDesktopModulesHardware = {
    config.hardwareModule = {
      gpu = {
        enable = true;
        brand = "nvidia";
      };
      razer.enable = true;
    };
  };
}
