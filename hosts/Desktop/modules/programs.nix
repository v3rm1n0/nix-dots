{ inputs, ... }:
{
  flake.nixosModules.hostDesktopModulesPrograms =
    {
      lib,
      pkgs,
      ...
    }:
    {
      config.programs = {
        ai.enable = true;
        browsing = {
          chromium = {
            enable = false;
            package = inputs.helium.defaultPackage.${pkgs.stdenv.hostPlatform.system};
          };
          firefox = {
            enable = true;
            package = pkgs.librewolf;
          };
        };
        content.enable = lib.mkForce true;
        dev.optionalPackages = [
          pkgs.zed-editor
        ];
        gaming.optionalPackages = [
          #pkgs.stoat-desktop
        ];
      };
    };
}
