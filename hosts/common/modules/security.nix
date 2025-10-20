{
  config.securityModule = {
    auth.enableGnomeKeyringFor = "ly";
    encryption = {
      age.enable = true;
      passwords.enable = true;
    };
    gpg.enable = true;
  };
}
