_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      hostUsernames,
      ...
    }:
    {
      options.mods.services.vicinae.enable = lib.mkEnableOption "Enable vicinae service";

      config = lib.mkIf config.mods.services.vicinae.enable (
        lib.mkMerge (
          [ { environment.systemPackages = [ pkgs.vicinae ]; } ]
          ++ map (username: {
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
          }) hostUsernames
        )
      );
    };
}
