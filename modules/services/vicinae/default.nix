_: {
  flake.nixosModules.modulesServicesVicinae =
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
      options.servicesModule.vicinae.enable = lib.mkEnableOption "Enable vicinae service";

      config = lib.mkIf config.servicesModule.vicinae.enable {
        environment.systemPackages = [ pkgs.vicinae ];

        hjem.users.${username} = {
          files.".config/vicinae/settings.json" = {
            generator = lib.generators.toJSON { };
            value = {
              favicon_service = "twenty";
              font.normal.normal = "Geist";
              theme.dark = {
                name = "gruvbox-dark";
                icon_theme = "default";
              };
              launcher_window.opacity = 0.8;
            };
          };

          systemd.services.vicinae = {
            description = "Vicinae application launcher";
            after = [ "graphical-session.target" ];
            partOf = [ "graphical-session.target" ];
            wantedBy = [ "graphical-session.target" ];
            serviceConfig = {
              ExecStart = "${pkgs.vicinae}/bin/vicinae server";
              Restart = "on-failure";
              Environment = "PATH=/run/wrappers/bin:/home/${username}/.nix-profile/bin:/etc/profiles/per-user/${username}/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
            };
          };
        };
      };
    };
}
