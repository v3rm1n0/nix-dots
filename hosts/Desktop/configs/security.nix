{ ... }:
{
  imports = [
    ./../../../modules
  ];

  securityModule = {
    auth.enableGnomeKeyringFor = "greetd";
    encryption = {
      age.enable = true;
      passwords.enable = true;
    };
    gpg.enable = true;
  };
}
