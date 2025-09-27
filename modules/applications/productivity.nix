{ lib, config, ... }:
{

  options.programs.productivity = {
    enable = lib.mkEnableOption "Enable the productivity programs";
  };

  config = lib.mkIf config.programs.productivity.enable {

  };

}
