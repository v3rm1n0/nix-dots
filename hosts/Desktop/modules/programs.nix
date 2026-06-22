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
            package = inputs.brave-origin.legacyPackages.${pkgs.stdenv.hostPlatform.system}.brave-origin;
          };
          firefox = {
            enable = true;
            package = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
          };
        };
        content.enable = lib.mkForce true;
        tdarr.enable = true;
        dev.optionalPackages = [
          pkgs.zed-editor
        ];
        gaming.optionalPackages = [
          #pkgs.stoat-desktop
        ];
      };
    };
}
