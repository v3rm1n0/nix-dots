{ self, inputs, ... }:
{
  flake.nixosModules.modulesShell =
    { config, pkgs, ... }:
    let
      inherit (config.userOptions) username;
    in
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager

        self.nixosModules.modulesShellBash
        self.nixosModules.modulesShellP10k
        self.nixosModules.modulesShellZsh
      ];

      home-manager.users.${username} = {
        programs.git = {
          enable = true;
          settings = {
            push.autoSetupRemote = "true";
            user = {
              name = "V3RM1N";
              email = "mail@v3rm1n.dev";
            };
          };
          signing = {
            format = "openpgp";
            key = "04A465051516159B";
            signByDefault = true;
          };
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
