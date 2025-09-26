{ spicetify-nix, ... }:
{
  imports = [ spicetify-nix.nixosModules.default ];

  programs.spicetify = {
    enable = true;
  };
}
