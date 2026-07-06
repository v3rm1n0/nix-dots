_: {
  flake.modules.nixos.default =
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
      options.mods.apps.productivity.enable = lib.mkEnableOption "Enable the office module";

      config = lib.mkIf config.mods.apps.productivity.enable {
        hjem.users.${username}.packages = with pkgs; [
          obsidian
          onlyoffice-desktopeditors
          zathura
        ];
      };
    };
}
