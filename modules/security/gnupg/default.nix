_: {
  flake.nixosModules.modulesSecurityGnupg =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
    in
    {
      options.securityModule.gpg.enable = lib.mkEnableOption "Enable the gpg module";

      config = lib.mkIf config.securityModule.gpg.enable {
        programs.gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
          pinentryPackage = pkgs.pinentry-gnome3;
          settings = {
            default-cache-ttl-ssh = 14400;
            max-cache-ttl-ssh = 14400;
          };
        };

        environment.systemPackages = [ pkgs.gnupg ];

        hjem.users.${username}.files.".gnupg/sshcontrol".text = ''
          2EAF5EEFD4334DD0130D5158FED38D4505C78DAF
        '';
      };
    };
}
