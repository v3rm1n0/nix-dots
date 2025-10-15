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

  environment.variables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GTK_USE_PORTAL = "1";
    GDK_BACKEND = "wayland,x11";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    QT_QPA_PLATFORM = "wayland";
    XCURSOR_SIZE = "24";
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
        monitor = map (
          m:
          let
            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position = "${toString m.x}x${toString m.y}}";
          in
          "${m.name},${if m.enabled then "${resolution},${position},1" else "disable"}"
        ) (config.monitors);

        workspace =
          builtins.concatLists (
            map (
              monitor:
              builtins.map (
                workspace:
                "${builtins.toString workspace}, monitor:${monitor.name}${
                  lib.optionalString (workspace == monitor.workspacePrimary) ", default:true"
                }"
              ) monitor.workspaces
            ) config.monitors
          )
          ++ [
            "2,split:v"
          ];

        "ecosystem:no_update_news" = true;

        input = {
          kb_layout = "us, de";
          kb_options = "grp:alt_shift_toggle";

          follow_mouse = "1";

          touchpad = {
            natural_scroll = "no";
          };

          numlock_by_default = true;
        };

        general = {
          gaps_in = "3";
          gaps_out = "3,10,10,10";
          border_size = "2";
          # "col.active_border" = "rgba(215,153,33,1) rgba(215,153,33,1) 45deg";
          # "col.inactive_border" = "rgba(585858aa)";
          layout = "dwindle";
        };

        misc = {
          disable_hyprland_logo = true;
        };

        decoration = {
          blur = {
            enabled = true;
            size = "3";
            passes = "1";
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
          "$mainMod, T, exec, wezterm"
          "$mainMod, C, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, E, exec, nemo"
          "$mainMod, V, togglefloating,"
          "$mainMod, P, pseudo, # dwindle"
          "$mainMod, Q, togglesplit, # dwindle"
          "$mainMod ALT_L, L, exec, hyprlock"
          "$mainMod, SPACE, exec, vicinae toggle"
          "$mainMod, R, exec, librewolf"

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

        windowrulev2 = [
          # General layout rule for workspace 2
          "workspace 2 silent, class:^(vesktop)$"
          "tile, class:^(vesktop)$"
          "workspace 2 silent, title:^(Spotify Premium)$"
          "tile, title:^(Spotify Premium)$"

          # General layout rule for workspace 7
          "workspace 8 silent, class:^(steam)$"
        ];
        exec-once = [ "vesktop" ];
      };
    };
  };
}
