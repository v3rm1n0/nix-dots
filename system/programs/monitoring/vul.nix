{ ... }:
{
  flake.nixosModules.coreProgramsMonitoringVulnix =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        vulnix
      ];
    };
}
