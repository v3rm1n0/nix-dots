{
  config,
  lib,
  ...
}:
let
  username = config.userOptions.username;
in
{
  options.programs.productivity = {
    enable = lib.mkEnableOption "Enable the office module";
  };

  config = lib.mkIf config.programs.productivity.enable {
    home-manager.users.${username}.programs = {
      onlyoffice.enable = true;
      zathura.enable = true;
    };
  };
}
