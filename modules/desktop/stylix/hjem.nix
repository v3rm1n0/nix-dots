_: {
  flake.nixosModules.modulesDesktopStylixHjem =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
      c = config.lib.stylix.colors;
      dark = config.stylix.polarity == "dark";

      cursorName = config.stylix.cursor.name;
      cursorSize = toString config.stylix.cursor.size;
      iconTheme = if dark then config.stylix.icons.dark else config.stylix.icons.light;
      gtkTheme = if dark then "adw-gtk3-dark" else "adw-gtk3";
      fontName = "${config.stylix.fonts.sansSerif.name} ${toString config.stylix.fonts.sizes.applications}";

      # Convert a 6-char hex color to "r, g, b" decimal string for rgba() CSS values.
      hexToDecParts =
        hex:
        let
          d =
            ch:
            {
              "0" = 0;
              "1" = 1;
              "2" = 2;
              "3" = 3;
              "4" = 4;
              "5" = 5;
              "6" = 6;
              "7" = 7;
              "8" = 8;
              "9" = 9;
              "a" = 10;
              "b" = 11;
              "c" = 12;
              "d" = 13;
              "e" = 14;
              "f" = 15;
            }
            .${ch};
          h = s: lib.foldl (a: ch: a * 16 + d ch) 0 (lib.stringToCharacters s);
        in
        "${toString (h (builtins.substring 0 2 hex))}, ${toString (h (builtins.substring 2 2 hex))}, ${
          toString (h (builtins.substring 4 2 hex))
        }";

      # Mirrors stylix modules/gtk/gtk.css.mustache
      gtkCss = ''
        @define-color accent_color #${c.base0D};
        @define-color accent_bg_color #${c.base0D};
        @define-color accent_fg_color #${c.base00};
        @define-color destructive_color #${c.base08};
        @define-color destructive_bg_color #${c.base08};
        @define-color destructive_fg_color #${c.base00};
        @define-color success_color #${c.base0B};
        @define-color success_bg_color #${c.base0B};
        @define-color success_fg_color #${c.base00};
        @define-color warning_color #${c.base0E};
        @define-color warning_bg_color #${c.base0E};
        @define-color warning_fg_color #${c.base00};
        @define-color error_color #${c.base08};
        @define-color error_bg_color #${c.base08};
        @define-color error_fg_color #${c.base00};
        @define-color window_bg_color #${c.base00};
        @define-color window_fg_color #${c.base05};
        @define-color view_bg_color #${c.base00};
        @define-color view_fg_color #${c.base05};
        @define-color headerbar_bg_color #${c.base01};
        @define-color headerbar_fg_color #${c.base05};
        @define-color headerbar_border_color rgba(${hexToDecParts c.base01}, 0.7);
        @define-color headerbar_backdrop_color @window_bg_color;
        @define-color headerbar_shade_color rgba(0, 0, 0, 0.07);
        @define-color headerbar_darker_shade_color rgba(0, 0, 0, 0.07);
        @define-color sidebar_bg_color #${c.base01};
        @define-color sidebar_fg_color #${c.base05};
        @define-color sidebar_backdrop_color @window_bg_color;
        @define-color sidebar_shade_color rgba(0, 0, 0, 0.07);
        @define-color secondary_sidebar_bg_color @sidebar_bg_color;
        @define-color secondary_sidebar_fg_color @sidebar_fg_color;
        @define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
        @define-color secondary_sidebar_shade_color @sidebar_shade_color;
        @define-color card_bg_color #${c.base01};
        @define-color card_fg_color #${c.base05};
        @define-color card_shade_color rgba(0, 0, 0, 0.07);
        @define-color dialog_bg_color #${c.base01};
        @define-color dialog_fg_color #${c.base05};
        @define-color popover_bg_color #${c.base01};
        @define-color popover_fg_color #${c.base05};
        @define-color popover_shade_color rgba(0, 0, 0, 0.07);
        @define-color shade_color rgba(0, 0, 0, 0.07);
        @define-color scrollbar_outline_color #${c.base02};
        @define-color blue_1 #${c.base0D};
        @define-color blue_2 #${c.base0D};
        @define-color blue_3 #${c.base0D};
        @define-color blue_4 #${c.base0D};
        @define-color blue_5 #${c.base0D};
        @define-color green_1 #${c.base0B};
        @define-color green_2 #${c.base0B};
        @define-color green_3 #${c.base0B};
        @define-color green_4 #${c.base0B};
        @define-color green_5 #${c.base0B};
        @define-color yellow_1 #${c.base0A};
        @define-color yellow_2 #${c.base0A};
        @define-color yellow_3 #${c.base0A};
        @define-color yellow_4 #${c.base0A};
        @define-color yellow_5 #${c.base0A};
        @define-color orange_1 #${c.base09};
        @define-color orange_2 #${c.base09};
        @define-color orange_3 #${c.base09};
        @define-color orange_4 #${c.base09};
        @define-color orange_5 #${c.base09};
        @define-color red_1 #${c.base08};
        @define-color red_2 #${c.base08};
        @define-color red_3 #${c.base08};
        @define-color red_4 #${c.base08};
        @define-color red_5 #${c.base08};
        @define-color purple_1 #${c.base0E};
        @define-color purple_2 #${c.base0E};
        @define-color purple_3 #${c.base0E};
        @define-color purple_4 #${c.base0E};
        @define-color purple_5 #${c.base0E};
        @define-color brown_1 #${c.base0F};
        @define-color brown_2 #${c.base0F};
        @define-color brown_3 #${c.base0F};
        @define-color brown_4 #${c.base0F};
        @define-color brown_5 #${c.base0F};
        @define-color light_1 #${c.base05};
        @define-color light_2 #${c.base05};
        @define-color light_3 #${c.base05};
        @define-color light_4 #${c.base05};
        @define-color light_5 #${c.base05};
        @define-color dark_1 #${c.base05};
        @define-color dark_2 #${c.base05};
        @define-color dark_3 #${c.base05};
        @define-color dark_4 #${c.base05};
        @define-color dark_5 #${c.base05};
      '';

      # Mirrors stylix modules/btop/hm.nix
      btopTheme = with c.withHashtag; ''
        #Generated by Stylix
        theme[main_bg]="${base00}"
        theme[main_fg]="${base05}"
        theme[title]="${base05}"
        theme[hi_fg]="${base0D}"
        theme[selected_bg]="${base03}"
        theme[selected_fg]="${base0D}"
        theme[inactive_fg]="${base04}"
        theme[graph_text]="${base06}"
        theme[meter_bg]="${base03}"
        theme[proc_misc]="${base06}"
        theme[cpu_box]="${base0E}"
        theme[mem_box]="${base0B}"
        theme[net_box]="${base0C}"
        theme[proc_box]="${base0D}"
        theme[div_line]="${base01}"
        theme[temp_start]="${base0B}"
        theme[temp_mid]="${base0A}"
        theme[temp_end]="${base08}"
        theme[cpu_start]="${base0B}"
        theme[cpu_mid]="${base0A}"
        theme[cpu_end]="${base08}"
        theme[free_start]="${base0A}"
        theme[free_mid]="${base0B}"
        theme[free_end]="${base0B}"
        theme[cached_start]="${base0C}"
        theme[cached_mid]="${base0C}"
        theme[cached_end]="${base0A}"
        theme[available_start]="${base08}"
        theme[available_mid]="${base0A}"
        theme[available_end]="${base0B}"
        theme[used_start]="${base0A}"
        theme[used_mid]="${base09}"
        theme[used_end]="${base08}"
        theme[download_start]="${base0B}"
        theme[download_mid]="${base0A}"
        theme[download_end]="${base08}"
        theme[upload_start]="${base0B}"
        theme[upload_mid]="${base0A}"
        theme[upload_end]="${base08}"
        theme[process_start]="${base0B}"
        theme[process_mid]="${base0A}"
        theme[process_end]="${base08}"
      '';
    in
    {
      # Stylix's cursor and GTK integration runs via home.pointerCursor / gtk.enable
      # (Home Manager only). Since this config uses hjem, replicate them here.
      environment.variables.XCURSOR_THEME = cursorName;
      environment.systemPackages = [
        config.stylix.cursor.package
        config.stylix.icons.package
        pkgs.adw-gtk3
      ];

      hjem.users.${username}.files = {
        # Makes the cursor theme the system default (picked up by GTK, SDL2, etc.)
        ".local/share/icons/default/index.theme".text = ''
          [Icon Theme]
          Name=Default
          Comment=Default cursor theme
          Inherits=${cursorName}
        '';

        # GTK — mirrors stylix/hm/cursor.nix + modules/gtk/hm.nix
        ".config/gtk-3.0/settings.ini".text = ''
          [Settings]
          gtk-application-prefer-dark-mode = ${if dark then "1" else "0"}
          gtk-cursor-theme-name = ${cursorName}
          gtk-cursor-theme-size = ${cursorSize}
          gtk-font-name = ${fontName}
          gtk-icon-theme-name = ${iconTheme}
          gtk-theme-name = ${gtkTheme}
        '';
        ".config/gtk-4.0/settings.ini".text = ''
          [Settings]
          gtk-application-prefer-dark-mode = ${if dark then "1" else "0"}
          gtk-cursor-theme-name = ${cursorName}
          gtk-cursor-theme-size = ${cursorSize}
          gtk-font-name = ${fontName}
          gtk-icon-theme-name = ${iconTheme}
        '';
        ".config/gtk-3.0/gtk.css".text = gtkCss;
        ".config/gtk-4.0/gtk.css".text = gtkCss;

        # btop — mirrors stylix modules/btop/hm.nix
        ".config/btop/themes/stylix.theme".text = btopTheme;
        ".config/btop/btop.conf".text = ''
          color_theme = "stylix"
          theme_background = false
        '';
      };
    };
}
