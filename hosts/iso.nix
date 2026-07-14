{ self, inputs, ... }:
let
  mkIso =
    variant:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        (
          { modulesPath, ... }:
          {
            imports = [ (modulesPath + "/installer/cd-dvd/${variant}") ];
            nixpkgs.hostPlatform = "x86_64-linux";
            environment.etc.dotfiles.source = self;
          }
        )
      ];
    };
in
{
  flake.nixosConfigurations = {
    iso-gnome = mkIso "installation-cd-graphical-gnome.nix";
    iso-minimal = mkIso "installation-cd-minimal.nix";
  };
}
