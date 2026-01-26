{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  defaultPackages = with pkgs; [
    ed-odyssey-materials-helper
    heroic-unwrapped
    lutris
    prismlauncher
    revolt-desktop
    wineWowPackages.stable
  ];

in
{
  options.programs.gaming = {
    enable = mkEnableOption "Gaming profile with various gaming tools";

    discordPackage = mkOption {
      type = types.nullOr types.package;
      default = pkgs.discord;
      example = [
        (pkgs.discord.override {withVencord = true;})
      ];
      description = "The Discord package you want to use e.g. special client";
    };

    optionalPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = [
        pkgs.discord
      ];
      description = "List of additional optional packages for gaming";
    };
  };

  config = mkIf config.programs.gaming.enable {
    environment.systemPackages = defaultPackages ++ config.programs.gaming.optionalPackages ++ [config.programs.gaming.discordPackage];

    programs = {
      steam = {
        enable = true;
        protontricks.enable = true;
      };
      gamemode.enable = true;
    };

    hardware.steam-hardware.enable = true;

    services.udev.extraRules = ''
      # Grant user access to Thrustmaster T.16000M joysticks for gaming
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="044f", ATTRS{idProduct}=="b10a", TAG+="uaccess"
    '';
  };
}
