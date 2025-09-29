{ config, lib, pkgs, ... }:
{
  options.securityModule.encryption.passwords = {
    enable = lib.mkEnableOption "Enable passwords module";
  };

  config = lib.mkIf config.securityModule.encryption.passwords.enable {
    environment = {
      systemPackages = with pkgs; [
        bitwarden
        #bitwarden-cli
        #bitwarden-menu
        proton-authenticator
      ];
    };
  };
}
