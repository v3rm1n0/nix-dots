{ inputs, ... }:
{
  flake.modules.nixos.default =
    {
      config,
      pkgs,
      ...
    }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          handbrake = inputs.handbrake-fix.legacyPackages.${prev.stdenv.hostPlatform.system}.handbrake;
          ccextractor = inputs.ccextractor-fix.legacyPackages.${prev.stdenv.hostPlatform.system}.ccextractor;
        })
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

      programs.nix-ld = {
        enable = true;
        libraries = (pkgs.steam-run.args.multiPkgs pkgs) ++ [
          pkgs.stdenv.cc.cc.lib
        ];
      };

      nixpkgs.config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-39.8.10"
        ];
      };

      environment.systemPackages = with pkgs; [
        better-control
        sbctl
      ];
    };
}
