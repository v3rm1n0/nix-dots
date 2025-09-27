{
  config,
  lib,
  pkgs,
  spicetify-nix,
  username,
  ...
}:
{
  imports = [ spicetify-nix.nixosModules.default ];

  options.programs.media = {
    enable = lib.mkEnableOption "Enables communication module";
  };

  config = lib.mkIf config.programs.media.enable {
    programs.spicetify = {
      enable = true;
    };

    home-manager.users.${username}.home.packages = with pkgs; [
      vlc
    ];
  };
}
