{
  config,
  lib,
  ...
}:
let
  username = config.userOptions.username;
in
{
  options.programs.terminal = {
    enable = lib.mkEnableOption "Enable terminal module";
  };

  config = lib.mkIf config.programs.terminal.enable {
    home-manager.users.${username} = {
      programs.wezterm = {
        enable = true;
        colorSchemes = {
          catppuccin-frappe = {
            rosewater = "#f2d5cf";
            flamingo = "#eebebe";
            pink = "#f4b8e4";
            mauve = "#ca9ee6";
            red = "#e78284";
            maroon = "#ea999c";
            peach = "#ef9f76";
            yellow = "#e5c890";
            green = "#a6d189";
            teal = "#81c8be";
            sky = "#99d1db";
            sapphire = "#85c1dc";
            blue = "#8caaee";
            lavender = "#babbf1";
            text = "#c6d0f5";
            subtext1 = "#b5bfe2";
            subtext0 = "#a5adce";
            overlay2 = "#949cbb";
            overlay1 = "#838ba7";
            overlay0 = "#737994";
            surface2 = "#626880";
            surface1 = "#51576d";
            surface0 = "#414559";
            base = "#303446";
            mantle = "#292c3c";
            crust = "#232634";
          };
        };
        enableZshIntegration = true;
        extraConfig = ''
          return {
            font = wezterm.font("GeistMono Nerd Font"),
            font_size = 10.0,
            color_scheme = "gruvbox_material_dark_hard",
            color_schemes = {
                ["gruvbox_material_dark_hard"] = {
                    foreground = "#D4BE98",
                    background = "#1D2021",
                    cursor_bg = "#D4BE98",
                    cursor_border = "#D4BE98",
                    cursor_fg = "#1D2021",
                    selection_bg = "#D4BE98" ,
                    selection_fg = "#3C3836",

                    ansi = {"#1d2021","#ea6962","#a9b665","#d8a657", "#7daea3","#d3869b", "#89b482","#d4be98"},
                    brights = {"#eddeb5","#ea6962","#a9b665","#d8a657", "#7daea3","#d3869b", "#89b482","#d4be98"},
                },
            },
            enable_tab_bar = false,
            window_background_opacity = 0.5
          }
        '';
      };
    };
  };
}
