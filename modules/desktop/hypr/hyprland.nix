# Hyprland Window Manager Configuration
#
# This module configures Hyprland, a dynamic tiling Wayland compositor.
# Hyprland provides smooth animations, dynamic tiling, and extensive customization.
#
# Key Features:
#   - Dynamic tiling with dwindle layout
#   - Vim-style navigation (hjkl)
#   - Multi-monitor support (configured in monitors.nix)
#   - XWayland support for legacy X11 applications
#   - Integration with systemd and XDG portals
#
# Keybindings Overview:
#   Super + T = Terminal
#   Super + R = Browser
#   Super + E = File Manager
#   Super + Space = Application Launcher
#   Super + C = Close Window
#   Super + hjkl = Navigate Windows (Vim-style)
#   Super + Shift + hjkl = Move Windows
#   Super + Ctrl + hjkl = Resize Windows
#   Super + 1-9 = Switch Workspaces
#   Super + Shift + 1-9 = Move Window to Workspace
#
# See: https://wiki.hyprland.org/ for detailed documentation

{
  config,
  lib,
  pkgs,
  ...
}:
let
  username = config.userOptions.username;
in
{
  imports = [
    ./monitors.nix
  ];

  # Environment variables for Wayland compatibility
  # These ensure applications properly detect and use Wayland
  environment.variables = {
    # Identify desktop environment
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";

    # GTK portal support for file pickers, etc.
    GTK_USE_PORTAL = "1";

    # GDK backend preference (Wayland first, X11 fallback)
    GDK_BACKEND = "wayland,x11";

    # Firefox Wayland support
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1"; # Required for some Firefox features on Wayland

    # Qt Wayland platform plugin
    QT_QPA_PLATFORM = "wayland";
  };

  home-manager.users.${username} = _: {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      systemd = {
        enable = true;
        enableXdgAutostart = true;
        variables = [
          "--all"
          "XDG_CURRENT_DESKTOP"
          "XDG_SESSION_TYPE"
        ];
      };
      settings = {
        # Monitor configuration
        # Dynamically generates monitor configs from the monitors.nix configuration
        # Format: "name,resolution@refreshRate,position,scale" or "name,disable"
        monitor = map (
          m:
          let
            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position = "${toString m.x}x${toString m.y}}";
          in
          "${m.name},${if m.enabled then "${resolution},${position},1" else "disable"}"
        ) (config.monitors);

        # Workspace to monitor assignment
        # This binds specific workspaces to specific monitors
        # Format: "workspace_id, monitor:monitor_name[, default:true]"
        workspace =
          builtins.concatLists (
            map (
              monitor:
              map (
                workspace:
                "${toString workspace}, monitor:${monitor.name}${
                  lib.optionalString (workspace == monitor.workspacePrimary) ", default:true"
                }"
              ) monitor.workspaces
            ) config.monitors
          )
          ++ [
            "2,split:v" # Workspace 2 uses vertical split layout
          ];

        "ecosystem:no_update_news" = true;

        # Input device configuration
        input = {
          kb_layout = "us, de"; # US and German keyboard layouts
          kb_options = "grp:alt_shift_toggle"; # Switch layouts with Alt+Shift

          follow_mouse = "1"; # Focus follows mouse

          touchpad = {
            natural_scroll = "no"; # Traditional scrolling direction
          };

          numlock_by_default = true;
        };

        # General window management settings
        general = {
          gaps_in = "5"; # Gap between windows
          gaps_out = "10"; # Gap between windows and screen edges (top, right, bottom, left)
          border_size = "2";
          # Border colors are managed by Stylix
          # "col.active_border" = "rgba(215,153,33,1) rgba(215,153,33,1) 45deg";
          # "col.inactive_border" = "rgba(585858aa)";
          layout = "dwindle"; # Use dwindle tiling algorithm
        };

        misc = {
          disable_hyprland_logo = true;
        };

        decoration = {
          rounding = "20";
          rounding_power = "2";
          blur = {
            enabled = true;
            size = "3";
            passes = "2";
            vibrancy = "0.1696";
          };
          shadow = {
            enabled = true;
            range = "4";
            render_power = "3";
            #color = "rgba(1a1a1aee)";
          };
        };

        animations = {
          enabled = true;
          bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.05" ];
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          split_width_multiplier = 1.35;
          pseudotile = true;
        };

        "$mainMod" = "SUPER";
        bind = [
          "$mainMod, T, exec, ghostty"
          "$mainMod, C, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, E, exec, nautilus"
          "$mainMod, V, togglefloating,"
          "$mainMod, P, pseudo, # dwindle"
          "$mainMod, Q, togglesplit, # dwindle"
          "$mainMod ALT_L, L, exec, hyprlock"
          "$mainMod, SPACE, exec, vicinae toggle"
          "$mainMod, R, exec, ${config.userOptions.browser}"

          "$mainMod, h, movefocus, l"
          "$mainMod, l, movefocus, r"
          "$mainMod, k, movefocus, u"
          "$mainMod, j, movefocus, d"
          "$mainMod SHIFT, h, movewindow, l"
          "$mainMod SHIFT, l, movewindow, r"
          "$mainMod SHIFT, k, movewindow, u"
          "$mainMod SHIFT, j, movewindow, d"
          "$mainMod CTRL, h, resizeactive, -50 0" # Shrink to left
          "$mainMod CTRL, l, resizeactive, 50 0" # Grow to right
          "$mainMod CTRL, k, resizeactive, 0 -50" # Shrink upward
          "$mainMod CTRL, j, resizeactive, 0 50" # Grow downward

          # ---- Workspace Keybinds---- #
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          # Make a screenshot
          "$mainMod SHIFT, s, exec, filename=~/Pictures/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png; grim -g \"$(slurp -d)\" \"$filename\" && wl-copy < \"$filename\""

          # Audio Controlls
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

          # Brightness controll
          ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
          ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        ];

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        # windowrulev3 or new windowrule
        windowrule = [
          {
            name = "discord-ws-2";
            workspace = "2 silent";
            tile = "on";
            "match:initial_class" = "^(${config.userOptions.discordClient})$";
          }
          {
            name = "spotify-ws-2";
            workspace = "2 silent";
            tile = "on";
            "match:initial_class" = "^(spotify)";
          }
          {
            name = "steam-ws-8";
            workspace = "8 silent";
            "match:initial_class" = "^(steam)";
          }
        ];
        exec-once = [
          "${config.userOptions.discordClient}"

        ];
      };
    };
  };
}
