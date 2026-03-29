{ self, inputs, ... }:
{
  flake.nixosModules.modulesHardware = {
    imports = [
      self.nixosModules.modulesHardwareGraphics
      self.nixosModules.modulesHardwareRazer
    ];
  };
}
