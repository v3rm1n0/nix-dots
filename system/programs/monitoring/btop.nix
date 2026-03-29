{ self, inputs, ... }:
{
  flake.nixosModules.coreProgramsMonitoringBtop =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        btop
        resources
      ];
    };
}
