{ inputs, ... }:
{
  flake.nixosModules.modulesDesktopStylix =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) colorScheme username;
      c = config.lib.stylix.colors;

      # Convert two hex chars to a decimal integer, used for rgba() values in CSS.
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
          r = h (builtins.substring 0 2 hex);
          g = h (builtins.substring 2 2 hex);
          b = h (builtins.substring 4 2 hex);
        in
        "${toString r}, ${toString g}, ${toString b}";

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

      dark = config.stylix.polarity == "dark";
      iconTheme = if dark then config.stylix.icons.dark else config.stylix.icons.light;
      gtkTheme = if dark then "adw-gtk3-dark" else "adw-gtk3";
      fontName = "${config.stylix.fonts.sansSerif.name} ${toString config.stylix.fonts.sizes.applications}";
      cursorName = config.stylix.cursor.name;
      cursorSize = toString config.stylix.cursor.size;
    in
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];

      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/${colorScheme}.yaml";

        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 25;
        };

        fonts = {
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
          monospace = {
            package = pkgs.nerd-fonts.geist-mono;
            name = "Geist Mono";
          };
          sansSerif = {
            package = pkgs.geist-font;
            name = "Geist";
          };
          serif = config.stylix.fonts.sansSerif;
          sizes = {
            applications = 12;
            desktop = 10;
            popups = 10;
            terminal = 10;
          };
        };

        polarity = "dark";

        icons = {
          enable = true;
          package = pkgs.kora-icon-theme;
          dark = "kora";
        };

        opacity.applications = 0.8;

        targets = {
          limine.image.enable = false;
        };
      };

      # Stylix's cursor and GTK setup rely on home.pointerCursor and gtk.enable
      # (Home Manager only). Since this config uses hjem, wire them up manually.
      environment.variables.XCURSOR_THEME = cursorName;
      environment.systemPackages = [
        config.stylix.cursor.package
        config.stylix.icons.package
        pkgs.adw-gtk3
      ];

      hjem.users.${username}.files = {
        ".local/share/icons/default/index.theme".text = ''
          [Icon Theme]
          Name=Default
          Comment=Default cursor theme
          Inherits=${cursorName}
        '';
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
      };
    };
}
