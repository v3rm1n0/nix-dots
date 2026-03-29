{ ... }:
{
  flake.nixosModules.hostLaptopModulesPrograms =
    { pkgs, ... }:
    {
      config.programs = {
        browsing = {
          chromium = {
            enable = true;
            package = pkgs.brave;
          };
        };
      };
    };
}
