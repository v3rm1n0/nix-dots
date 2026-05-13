{ self, ... }:
{
  flake.nixosModules.modulesShell =
    { config, pkgs, ... }:
    {
      imports = [
        self.nixosModules.modulesShellBash
        self.nixosModules.modulesShellP10k
        self.nixosModules.modulesShellZsh
      ];

      programs.git = {
        enable = true;
        config = {
          push.autoSetupRemote = "true";
          user = {
            name = "V3RM1N";
            email = "mail@v3rm1n.dev";
          };
          commit.gpgsign = true;
          gpg.format = "openpgp";
          user.signingkey = "04A465051516159B";
        };
      };

      environment.systemPackages = with pkgs; [
        acpi
        bat
        bat-extras.batman
        clang
        deadnix
        eza
        gh
        glow
        nixd
        nixfmt
        statix
        tirith
        unzip
        zoxide
      ];
    };
}
