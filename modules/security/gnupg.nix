_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      hostUsernames,
      userProfiles,
      ...
    }:
    let
      adminUser = lib.head (builtins.filter (n: userProfiles.${n}.isAdmin) hostUsernames);
    in
    {
      options.mods.security.gnupg.enable = lib.mkEnableOption "Enable the gpg module";

      config = lib.mkIf config.mods.security.gnupg.enable {
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

        hjem.users.${adminUser}.files.".gnupg/sshcontrol".text = ''
          2EAF5EEFD4334DD0130D5158FED38D4505C78DAF
        '';
      };
    };
}
