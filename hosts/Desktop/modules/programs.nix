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
            enable = true;
            package = inputs.brave-origin.legacyPackages.${pkgs.stdenv.hostPlatform.system}.brave-origin;
          };
          firefox = {
            enable = true;
            package = pkgs.librewolf;
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
