{ inputs, ... }:
{
  flake.nixosModules.applicationsMedia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
    in
    {
      imports = [
        inputs.spicetify-nix.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
      ];

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
    };
}
