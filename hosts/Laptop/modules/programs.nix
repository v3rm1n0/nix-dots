{ inputs, ... }:
{
  flake.nixosModules.hostLaptopModulesPrograms =
    { pkgs, ... }:
    {
      config.programs = {
        browsing = {
          chromium = {
            enable = true;
            package = inputs.helium.defaultPackage.${pkgs.stdenv.hostPlatform.system};
          };
        };
      };
    };
}
