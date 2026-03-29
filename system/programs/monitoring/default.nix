{ self, inputs, ... }:
{
  flake.nixosModules.coreProgramsMonitoring = {
    imports = [
      self.nixosModules.coreProgramsMonitoringBtop
      self.nixosModules.coreProgramsMonitoringCava
      self.nixosModules.coreProgramsMonitoringFastfetch
      self.nixosModules.coreProgramsMonitoringVulnix
    ];
  };
}
