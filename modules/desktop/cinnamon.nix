_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      hostUsernames,
      userProfiles,
      ...
    }:
    let
      cinnamonUsers = builtins.filter (n: userProfiles.${n}.wm == "cinnamon") hostUsernames;
    in
    {
      options.mods.desktop.cinnamon.enable = lib.mkOption {
        type = lib.types.bool;
        default = cinnamonUsers != [ ];
        description = "Enable the Cinnamon desktop session.";
      };

      config = lib.mkIf config.mods.desktop.cinnamon.enable {
        services.xserver.enable = true;
        services.xserver.desktopManager.cinnamon.enable = true;

        environment.systemPackages = [ pkgs.ghostty ];

        programs.dconf.profiles.user.databases = [
          {
            settings."org/cinnamon/desktop/default-applications/terminal" = {
              exec = "ghostty";
            };
            settings."org/gnome/desktop/default-applications/terminal" = {
              exec = "ghostty";
            };
          }
        ];
      };
    };
}
