{ config, lib, ... }:

{
  options.securityModule.auth.enableGnomeKeyringFor = lib.mkOption {
    type = lib.types.str;
    default = "greetd";
    description = "Service to enable gnome-keyring for.";
  };

  config = lib.mkIf (config.securityModule.auth.enableGnomeKeyringFor != null) {
    security.pam.services.${config.securityModule.auth.enableGnomeKeyringFor}.enableGnomeKeyring = true;
    security.pam.services.login.enableGnomeKeyring = true;
  };
}
