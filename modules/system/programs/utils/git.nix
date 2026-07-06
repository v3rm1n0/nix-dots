_: {
  flake.modules.nixos.default =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
    in
    {
      environment.systemPackages = with pkgs; [ jujutsu ];

      hjem.users.${username}.rum.programs.git = {
        enable = true;
        settings = {
          commit.gpgsign = true;
          gpg.format = "openpgp";
          push.autoSetupRemote = "true";
          user = {
            name = "V3RM1N";
            email = "mail@v3rm1n.dev";
            signingkey = "04A465051516159B";
          };
        };
      };
    };
}
