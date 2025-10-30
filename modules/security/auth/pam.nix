{
    security.pam.services.ly = {
      enableGnomeKeyring = true;
      text = ''
        auth     include login
        account  include login
        password include login
        session  include login
      '';
    };
    security.pam.services = {
      login.enableGnomeKeyring = true;
      hyprlock.enableGnomeKeyring = true;
    };
}
