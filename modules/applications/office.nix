{ username, ... }:
{
  home-manager.users.${username}.programs = {
    onlyoffice.enable = true;
    zathura.enable = true;
  };
}
