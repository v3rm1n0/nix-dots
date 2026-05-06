_: {
  flake.nixosModules.modulesSecuritySsh =
    { config, lib, ... }:
    let
      cfg = config.securityModule.ssh;
    in
    {
      options.securityModule.ssh = {
        enable = lib.mkEnableOption "SSH server and client configuration";
      };

      config = lib.mkIf cfg.enable {
        programs.ssh.extraConfig = ''
          Host *
            AddKeysToAgent yes
            IdentityFile ~/.ssh/id_ed25519
        '';
        services.openssh = {
          enable = true;
          ports = [ 4545 ];
          settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            X11Forwarding = false;
          };
        };
      };
    };
}
