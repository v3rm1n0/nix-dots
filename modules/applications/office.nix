{
  config,
  lib,
  username,
  ...
}:
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
