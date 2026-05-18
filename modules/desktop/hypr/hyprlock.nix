_: {
  flake.nixosModules.modulesDesktopHyprHyprlock =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username wallpaper;
      colors = config.lib.stylix.colors;
      font = config.stylix.fonts.sansSerif.name;
    in
    {
      environment.systemPackages = [ pkgs.hyprlock ];

      hjem.users.${username}.files.".config/hypr/hyprlock.conf".text = ''
        background {
          monitor =
          path = /home/${username}/.config/backgrounds/${wallpaper}
          blur_passes = 3
          blur_size = 7
          brightness = 0.5
        }

        label {
          monitor =
          text = $TIME
          color = rgba(${colors.base05}ff)
          font_size = 72
          font_family = ${font}
          position = 0, 200
          halign = center
          valign = center
        }

        label {
          monitor =
          text = cmd[update:60000] date "+%A, %B %d"
          color = rgba(${colors.base04}ff)
          font_size = 20
          font_family = ${font}
          position = 0, 120
          halign = center
          valign = center
        }

        input-field {
          monitor =
          size = 300, 50
          outline_thickness = 2
          dots_size = 0.25
          dots_spacing = 0.3
          dots_center = true
          outer_color = rgb(${colors.base0D})
          inner_color = rgb(${colors.base00})
          font_color = rgb(${colors.base05})
          check_color = rgb(${colors.base0B})
          fail_color = rgb(${colors.base08})
          fade_on_empty = true
          placeholder_text = Password
          hide_input = false
          position = 0, 0
          halign = center
          valign = center
        }
      '';
    };
}
