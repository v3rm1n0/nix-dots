{ inputs, ... }:
{
  flake.nixosModules.hostLaptopModulesPrograms =
    { pkgs, ... }:
    {
      config.programs = {
        browsing = {
          chromium = {
            enable = true;
            package = inputs.brave-origin.legacyPackages.${pkgs.stdenv.hostPlatform.system}.brave-origin;
          };
        };
      };
    };
}
