_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      defaultPackages = with pkgs; [
        ed-odyssey-materials-helper
        heroic-unwrapped
        prismlauncher
      ];

    in
    {
      options.mods.apps.gaming = {
        enable = lib.mkEnableOption "Gaming profile with various gaming tools";
        optionalPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          example = [
            pkgs.lunar-client
          ];
          description = "List of additional optional packages for gaming";
        };
      };

      config = lib.mkIf config.mods.apps.gaming.enable {
        environment.systemPackages = defaultPackages ++ config.mods.apps.gaming.optionalPackages;

        programs = {
          steam = {
            enable = true;
            protontricks.enable = true;
          };
          gamemode.enable = true;
          gamescope.enable = true;
        };

        hardware.steam-hardware.enable = true;

        services.udev.extraRules = ''
          # Grant user access to Thrustmaster T.16000M joysticks for gaming
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="044f", ATTRS{idProduct}=="b10a", TAG+="uaccess"
        '';
      };
    };
}
