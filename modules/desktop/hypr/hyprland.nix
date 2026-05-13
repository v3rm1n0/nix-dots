{ self, ... }:
{
  flake.nixosModules.modulesDesktopHyprHyprland =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (config.userOptions) username;
      inherit (config.lib.stylix) colors;

      toHyprValue =
        v:
        if builtins.isString v then
          v
        else if builtins.isBool v then
          (if v then "true" else "false")
        else if builtins.isInt v || builtins.isFloat v then
          toString v
        else
          builtins.toJSON v;

      sortKeys =
        attrs:
        let
          keys = builtins.attrNames attrs;
          first = [
            "bezier"
            "name"
          ];
          priority = lib.filter (k: builtins.elem k first) keys;
          rest = lib.filter (k: !(builtins.elem k first)) keys;
        in
        priority ++ rest;

      renderAttrs =
        indent: attrs:
        lib.concatMapStrings (
          k:
          let
            v = attrs.${k};
          in
          if builtins.isAttrs v then
            "${indent}${k} {\n${renderAttrs "${indent}  " v}${indent}}\n"
          else if builtins.isList v then
            lib.concatMapStrings (
              item:
              if builtins.isAttrs item then
                "${indent}${k} {\n${renderAttrs "${indent}  " item}${indent}}\n"
              else
                "${indent}${k} = ${toHyprValue item}\n"
            ) v
          else
            "${indent}${k} = ${toHyprValue v}\n"
        ) (sortKeys attrs);

      toHyprConf = settings: renderAttrs "" settings;

      hyprlandSettings = {
        monitor = map (
          m:
          let
            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position = "${toString m.x}x${toString m.y}";
          in
          "${m.name},${if m.enabled then "${resolution},${position},1" else "disable"}"
        ) config.monitors;

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
          ++ [ "2,split:v" ];

        "ecosystem:no_update_news" = true;

        input = {
          kb_layout = "us, de";
          follow_mouse = "1";
          touchpad.natural_scroll = "no";
          numlock_by_default = true;
        };

        general = {
          gaps_in = "5";
          gaps_out = "10";
          border_size = "2";
          layout = "dwindle";
          "col.active_border" = "rgb(${colors.base0D})";
          "col.inactive_border" = "rgb(${colors.base03})";
        };

        misc.disable_hyprland_logo = true;

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
          };
        };

        bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.05" ];

        animations = {
          enabled = true;
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

        "$mainMod" = "ALT_L";

        bind = [
          "$mainMod, T, exec, ghostty"
          "Shift_L&Alt_L, Q, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, E, exec, nautilus"
          "$mainMod, V, togglefloating,"
          "$mainMod, P, pseudo, # dwindle"
          "Super_L&Alt_L, L, exec, hyprlock"
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
          "$mainMod CTRL, h, resizeactive, -50 0"
          "$mainMod CTRL, l, resizeactive, 50 0"
          "$mainMod CTRL, k, resizeactive, 0 -50"
          "$mainMod CTRL, j, resizeactive, 0 50"
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
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
          "$mainMod SHIFT, s, exec, wayfreeze & sleep 0.2 && grim -g \"$(slurp)\" - | tee ~/Pictures/$(date +%Y%m%d_%H%M%S).png | wl-copy; kill %1"
          "$mainMod SHIFT, Home, exec, grim -g \"$(hyprctl monitors -j | jq -r '.[] | \"\\(.x),\\(.y) \\(.width)x\\(.height)\"' | slurp)\" - | tee ~/Pictures/$(date +%Y%m%d_%H%M%S).png | wl-copy"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
          ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
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

        exec-once = [
          "noctalia-shell"
          "TeamSpeak"
        ];
      };
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

      hjem.users.${username}.files.".config/hypr/hyprland.conf" = {
        text = toHyprConf hyprlandSettings;
      };
    };
}
