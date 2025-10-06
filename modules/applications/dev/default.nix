{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  defaultPackages = [
    #--- Editors ---#
    pkgs.vscode
    #--- Tools ---#
    pkgs.devenv
    pkgs.gitkraken
    pkgs.nodejs_latest
    pkgs.nodePackages.prettier
    pkgs.nix-output-monitor
  ];
in
{
  options.programs.dev = {
    enable = mkEnableOption "Enable developer tools";

    optionalPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = [
        pkgs.nodejs_latest
        pkgs.gitkraken
      ];
      description = "List of optional packages to install alongside the default ones.";
    };
  };

  config = mkIf config.programs.dev.enable {
    environment.systemPackages = defaultPackages ++ config.programs.dev.optionalPackages;
  };
}
