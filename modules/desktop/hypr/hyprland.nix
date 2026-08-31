{
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
      hyprUsers = builtins.filter (n: userProfiles.${n}.wm == "hyprland") hostUsernames;
      inherit (config.lib.stylix) colors;

      monitor = map (
        m:
        if m.enabled then
          "${m.name}, ${toString m.width}x${toString m.height}@${toString m.refreshRate}, ${toString m.x}x${toString m.y}, ${toString m.scale}, vrr, ${toString m.vrr}, bitdepth, ${toString m.bitdepth}, cm, ${toString m.cm}"
        else
          "${m.name}, disable"
      ) config.mods.desktop.monitors;

      workspace = lib.concatMap (
        m:
        map (
          ws:
          "${toString ws}, monitor:${m.name}${lib.optionalString (ws == m.workspacePrimary) ", default:true"}"
        ) m.workspaces
      ) config.mods.desktop.monitors;

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

      flameshotSelect = pkgs.writeShellApplication {
        name = "flameshot-select";
        runtimeInputs = [ pkgs.jq ];
        text = builtins.readFile ./scripts/flameshot-select.sh;
      };

      mkHyprlandSettings = browser: {
        "$mainMod" = "SUPER";

        inherit monitor workspace;

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

        misc = {
          disable_hyprland_logo = true;
        };

        cursor = {
          no_hardware_cursors = true;
          no_break_fs_vrr = true;
        };

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

        bind = [
          "$mainMod, T, exec, ghostty"
          "$mainMod SHIFT, Q, killactive"
          "$mainMod, M, exit"
          "$mainMod, E, exec, nautilus"
          "$mainMod, V, togglefloating"
          "$mainMod, P, pseudo"
          "$mainMod SHIFT, L, exec, hyprlock"
          "$mainMod, SPACE, exec, vicinae toggle"
          "$mainMod, R, exec, ${browser}"

          "$mainMod, h, movefocus, l"
          "$mainMod, l, movefocus, r"
          "$mainMod, k, movefocus, u"
          "$mainMod, j, movefocus, d"

          "$mainMod SHIFT , h, movewindow, l"
          "$mainMod SHIFT , l, movewindow, r"
          "$mainMod SHIFT , k, movewindow, u"
          "$mainMod SHIFT , j, movewindow, d"

          "$mainMod CTRL , h, resizeactive, -50 0"
          "$mainMod CTRL , l, resizeactive, 50 0"
          "$mainMod CTRL , k, resizeactive, 0 -50"
          "$mainMod CTRL , j, resizeactive, 0 50"

          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ]
        ++ workspaceBinds
        ++ [
          "$mainMod SHIFT , s, exec, flameshot-select"
          "$mainMod SHIFT , Home, exec, flameshot screen -c -p ~/Pictures"
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
          {
            name = "flameshot-float-top";
            float = "on";
            pin = "on";
            "match:title" = "^(flameshot)$";
          }
        ];
      };
    in
    {
      config = lib.mkIf config.mods.desktop.hypr.enable (
        lib.mkMerge (
          [
            {
              environment.variables = {
                XDG_CURRENT_DESKTOP = "Hyprland";
                XDG_SESSION_DESKTOP = "Hyprland";
                GTK_USE_PORTAL = "1";
                GDK_BACKEND = "wayland,x11";
                MOZ_ENABLE_WAYLAND = "1";
                QT_QPA_PLATFORM = "wayland";
              };

              environment.systemPackages = [ flameshotSelect ];
            }
          ]
          ++ map (username: {
            hjem.users.${username}.rum.desktops.hyprland = {
              enable = true;
              settings = mkHyprlandSettings userProfiles.${username}.browser;
            };
          }) hyprUsers
        )
      );
    };
}
