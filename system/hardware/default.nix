{ self, inputs, ... }:
{

  flake.nixosModules.coreHardware = {
    imports = [
      self.nixosModules.coreHardwareBluetooth
      self.nixosModules.coreHardwareGraphics
      self.nixosModules.coreHardwareNetwork
      self.nixosModules.coreHardwarePipewire
      self.nixosModules.coreHardwarePrinting
      self.nixosModules.coreHardwareWebcam
    ];
  };
}
