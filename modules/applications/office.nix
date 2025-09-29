{
  config,
  lib,
  ...
}:
let
  username = config.userOptions.username;
in 
{
  options.programs.office = {
    enable = lib.mkEnableOption "Enable the office module";
  };

  config = lib.mkIf config.programs.office.enable {
    home-manager.users.${username}.programs = {
      onlyoffice.enable = true;
      zathura.enable = true;
    };
  };
}
