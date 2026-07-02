{ self, ... }:
{
  flake.nixosModules.modulesDesktopHyprHyprland =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (config.userOptions) username browser;
      inherit (config.lib.stylix) colors;

      monitor = map (
        m:
        if m.enabled then
          "${m.name}, ${toString m.width}x${toString m.height}@${toString m.refreshRate}, ${toString m.x}x${toString m.y}, 1"
        else
          "${m.name}, disable"
      ) config.monitors;

      workspace = lib.concatMap (
        m:
        map (
          ws:
          "${toString ws}, monitor:${m.name}${lib.optionalString (ws == m.workspacePrimary) ", default:true"}"
        ) m.workspaces
      ) config.monitors;

      # $mainMod .. key focus/move bindings for workspaces 1-10 (key 0 for 10).
      workspaceBinds = lib.concatMap (
        i:
        let
          key = if i == 10 then "0" else toString i;
        in
        [
          "$mainMod, ${key}, workspace, ${toString i}"
          "SHIFT $mainMod, ${key}, movetoworkspace, ${toString i}"
        ]
      ) (lib.range 1 10);
    in
    {
      imports = [ self.nixosModules.modulesDesktopHyprMonitors ];

      environment.variables = {
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
        GTK_USE_PORTAL = "1";
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        QT_QPA_PLATFORM = "wayland";
      };

      hjem.users.${username}.rum.desktops.hyprland = {
        enable = true;
        settings = {
          "$mainMod" = "ALT";

          inherit monitor workspace;
          # NOTE: the old Lua config also forced a vertical split on workspace 2
          # (layout_opts.split = "v"); dwindle has no per-workspace split rule in
          # hyprland.conf, so that micro-tweak is intentionally dropped.

          general = {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 2;
            layout = "dwindle";
            "col.active_border" = "rgb(${colors.base0D})";
            "col.inactive_border" = "rgb(${colors.base03})";
          };

          decoration = {
            rounding = 20;
            rounding_power = 2;
            blur = {
              enabled = true;
              size = 3;
              passes = 2;
              vibrancy = "0.1696";
            };
            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
            };
          };

          animations.enabled = true;

          input = {
            kb_layout = "us, de";
            follow_mouse = 1;
            numlock_by_default = true;
            touchpad.natural_scroll = false;
          };

          misc.disable_hyprland_logo = true;

          dwindle.split_width_multiplier = "1.35";

          ecosystem.no_update_news = true;

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];

          exec-once = [
            "noctalia-shell"
            "TeamSpeak"
          ];

          bind =
            [
              "$mainMod, T, exec, ghostty"
              "SHIFT ALT, Q, killactive"
              "$mainMod, M, exit"
              "$mainMod, E, exec, nautilus"
              "$mainMod, V, togglefloating"
              "$mainMod, P, pseudo"
              "SUPER ALT, L, exec, hyprlock"
              "$mainMod, SPACE, exec, vicinae toggle"
              "$mainMod, R, exec, ${browser}"

              "$mainMod, h, movefocus, l"
              "$mainMod, l, movefocus, r"
              "$mainMod, k, movefocus, u"
              "$mainMod, j, movefocus, d"

              "SHIFT $mainMod, h, movewindow, l"
              "SHIFT $mainMod, l, movewindow, r"
              "SHIFT $mainMod, k, movewindow, u"
              "SHIFT $mainMod, j, movewindow, d"

              "CTRL $mainMod, h, resizeactive, -50 0"
              "CTRL $mainMod, l, resizeactive, 50 0"
              "CTRL $mainMod, k, resizeactive, 0 -50"
              "CTRL $mainMod, j, resizeactive, 0 50"

              "$mainMod, mouse_down, workspace, e+1"
              "$mainMod, mouse_up, workspace, e-1"
            ]
            ++ workspaceBinds
            ++ [
              ''SHIFT $mainMod, s, exec, wayfreeze & sleep 0.2 && grim -g "$(slurp)" - | tee ~/Pictures/$(date +%Y%m%d_%H%M%S).png | wl-copy; kill %1''
              ''SHIFT $mainMod, Home, exec, grim -g "$(hyprctl monitors -j | jq -r '.[] | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)" - | tee ~/Pictures/$(date +%Y%m%d_%H%M%S).png | wl-copy''
            ];

          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          bindel = [
            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
          ];

          bindl = [
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
            ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
          ];

          windowrule = [
	          {
	            name = "teamspeak-ws-2";
	            workspace = "2 silent";
	            tile = "on";
	            "match:initial_class" = "^(teamspeak-client)";
	          }
	          {
	            name = "discord-ws-2";
	            workspace = "2 silent";
	            tile = "on";
	            "match:initial_class" = "^(equibop)$";
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
        };
      };
    };
}
