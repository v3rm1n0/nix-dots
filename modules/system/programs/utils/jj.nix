_: {
  flake.modules.nixos.default =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
      toml = pkgs.formats.toml { };

      settings = {
        user = {
          name = "V3RM1N";
          email = "mail@v3rm1n.dev";
        };

        # Sign with gpg, but lazily: only on push.
        signing = {
          behavior = "own";
          backend = "gpg";
          key = "04A465051516159B";
        };

        revsets.git-sign-on-push = "~signed() & mine()";
      };
    in
    {
      environment.systemPackages = [ pkgs.jujutsu ];

      hjem.users.${username}.files.".config/jj/config.toml".source =
        toml.generate "jj-config.toml" settings;
    };
}
