_: {
  flake.nixosModules.coreProgramsMonitoringCava =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        cava
      ];
    };
}
