{ inputs, ... }:
{
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username wallpaper;
      cfg = config.mods.desktop.noctalia;
      colors = config.lib.stylix.colors;
      wallpaperDir = "/home/${username}/.config/backgrounds";
    in
    {
      options.mods.desktop.noctalia = {
        enable = lib.mkEnableOption "the Noctalia shell";
        withBattery = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Show the battery widget in the bar.";
        };
      };

      config = lib.mkIf cfg.enable {
        hjem.extraModules = [ inputs.noctalia.hjemModules.default ];

        hjem.users.${username}.programs.noctalia = {
          enable = true;
          settings = {
            accessibility.ui_scale = 0.9;
            shell.shadow.direction = "up_right";
            location.address = "Viersen, Germany";

            theme = {
              mode = "dark";
              source = "custom";
              custom_palette = "stylix";
            };

            wallpaper = {
              directory = wallpaperDir;
              default.path = "${wallpaperDir}/${wallpaper}";
            };

            dock.enabled = false;

            bar.main = {
              position = "top";
              thickness = 30;
              margin_ends = 10;
              margin_edge = 8;
              capsule = false;
              start = [
                "control-center"
                "cpu"
                "ram"
                "net-rx"
                "net-tx"
                "workspaces"
                "audio_visualizer"
                "media"
              ];
              center = [ "active_window" ];
              end = [
                "volume"
                "network"
                "bluetooth"
              ]
              ++ lib.optional cfg.withBattery "battery"
              ++ [
                "keyboard_layout"
                "tray"
                "notifications"
                "clock"
              ];
            };

            widget = {
              control-center = {
                custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                custom_image_colorize = true;
              };
              audio_visualizer.width = 100;
              media.hide_when_idle = true;
              keyboard_layout.show_glyph = false;
              clock = {
                format = "{:%H:%M}";
                vertical_format = "{:%H\n%M}";
                font_family = "monospace";
                color = "primary";
              };
            };
          };

          customPalettes.stylix.dark = with colors.withHashtag; {
            mPrimary = base0D;
            mOnPrimary = base00;
            mSecondary = base0E;
            mOnSecondary = base00;
            mTertiary = base0C;
            mOnTertiary = base00;
            mError = base08;
            mOnError = base00;
            mSurface = base00;
            mOnSurface = base05;
            mHover = base0C;
            mOnHover = base00;
            mSurfaceVariant = base01;
            mOnSurfaceVariant = base04;
            mOutline = base03;
            mShadow = base00;
            # palettes without a terminal block are rejected and fall back to the builtin theme
            terminal =
              let
                ansi = {
                  red = base08;
                  green = base0B;
                  yellow = base0A;
                  blue = base0D;
                  magenta = base0E;
                  cyan = base0C;
                };
              in
              {
                background = base00;
                foreground = base05;
                cursor = base05;
                cursorText = base00;
                selectionBg = base02;
                selectionFg = base05;
                normal = ansi // {
                  black = base00;
                  white = base05;
                };
                bright = ansi // {
                  black = base03;
                  white = base07;
                };
              };
          };
        };
      };
    };
}
