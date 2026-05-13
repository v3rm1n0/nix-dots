{ self, inputs, ... }:
{
  flake.nixosModules.coreNix =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) dots;
    in
    {
      imports = [
        self.nixosModules.coreNixBtrfs
        self.nixosModules.coreNixGc
        self.nixosModules.coreNixSettings
      ];

      system = {
        autoUpgrade = {
          enable = true;
          flake = "${config.userOptions.dots}";
          flags = [ "-L" ];
          dates = "weekly";
          upgrade = true;
        };
        systemBuilderCommands = ''
          ln -sv ${pkgs.path} $out/nixpkgs
        '';
        stateVersion = "23.11";
      };

      nix = {
        package = pkgs.nixVersions.latest;
        nixPath = [ "nixpkgs=/run/current-system/nixpkgs/" ];
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.nh = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.nh;
      };

      programs.nix-ld = {
        enable = true;
        libraries = (pkgs.steam-run.args.multiPkgs pkgs) ++ [
          pkgs.stdenv.cc.cc.lib
        ];
      };

      nixpkgs.config = {
        allowUnfree = true;
        permittedInsecurePackages = [ ];
      };

      environment.systemPackages = with pkgs; [
        better-control
        sbctl
      ];
    };
}
