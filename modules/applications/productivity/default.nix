_: {
  flake.nixosModules.applicationsProductivity =
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
      options.programs.productivity.enable = lib.mkEnableOption "Enable the office module";

      config = lib.mkIf config.programs.productivity.enable {
        hjem.users.${username}.packages = with pkgs; [
          obsidian
          onlyoffice-desktopeditors
          zathura
        ];
      };
    };
}
