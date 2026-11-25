{
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username browser;
      inherit (config.lib.stylix) colors;

      monitorsLua = lib.concatMapStrings (
        m:
        if m.enabled then
          ''
            hl.monitor({
              output = "${m.name}",
              mode = "${toString m.width}x${toString m.height}@${toString m.refreshRate}",
              position = "${toString m.x}x${toString m.y}",
              scale = ${toString m.scale},
              vrr = ${toString m.vrr},
              bitdepth = ${toString m.bitdepth},
              cm = "${m.cm}",
            })
          ''
        else
          ''
            hl.monitor({ output = "${m.name}", disabled = true })
          ''
      ) config.mods.desktop.monitors;

      workspacesLua = lib.concatStrings (
        lib.concatMap (
          m:
          map (ws: ''
            hl.workspace_rule({ workspace = "${toString ws}", monitor = "${m.name}"${
              lib.optionalString (ws == m.workspacePrimary) ", default = true"
            } })
          '') m.workspaces
        ) config.mods.desktop.monitors
      );

      # See scripts/flameshot-select.sh for why this exists.
      flameshotSelect = pkgs.writeShellApplication {
        name = "flameshot-select";
        runtimeInputs = [ pkgs.jq ];
        text = builtins.readFile ./scripts/flameshot-select.sh;
      };
    in
    {
      config = lib.mkIf config.mods.desktop.hypr.enable {
        environment.variables = {
          XDG_CURRENT_DESKTOP = "Hyprland";
          XDG_SESSION_DESKTOP = "Hyprland";
          GTK_USE_PORTAL = "1";
          GDK_BACKEND = "wayland,x11";
          MOZ_ENABLE_WAYLAND = "1";
          QT_QPA_PLATFORM = "wayland";
        };

        environment.systemPackages = [ flameshotSelect ];

        hjem.users.${username}.xdg.config.files."hypr/hyprland.lua".text = ''
          local mainMod = "SUPER"

          ${monitorsLua}
          ${workspacesLua}
          hl.workspace_rule({ workspace = "2", layout_opts = { split = "v" } })

          hl.config({
            general = {
              gaps_in = 5,
              gaps_out = 10,
              border_size = 2,
              layout = "dwindle",
              col = {
                active_border = "rgb(${colors.base0D})",
                inactive_border = "rgb(${colors.base03})",
              },
            },
            decoration = {
              rounding = 20,
              rounding_power = 2,
              blur = {
                enabled = true,
                size = 3,
                passes = 2,
                vibrancy = 0.1696,
              },
              shadow = {
                enabled = true,
                range = 4,
                render_power = 3,
              },
            },
            animations = { enabled = false },
            input = {
              kb_layout = "us, de",
              follow_mouse = 1,
              numlock_by_default = true,
              touchpad = { natural_scroll = false },
            },
            misc = { disable_hyprland_logo = true },
            cursor = {
              no_hardware_cursors = 1,
              no_break_fs_vrr = 1,
            },
            dwindle = { split_width_multiplier = 1.35 },
            ecosystem = { no_update_news = true },
          })

          hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

          hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
          hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
          hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
          hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
          hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
          hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })

          hl.on("hyprland.start", function()
            hl.exec_cmd("noctalia")
            hl.exec_cmd("discord")
          end)

          hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("ghostty"))
          hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
          hl.bind(mainMod .. " + M", hl.dsp.exit())
          hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("nautilus"))
          hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
          hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
          hl.bind("CTRL + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))
          hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("vicinae toggle"))
          hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("${browser}"))

          local dirs = { h = "left", l = "right", k = "up", j = "down" }
          local resize = {
            h = { x = -50, y = 0 },
            l = { x = 50, y = 0 },
            k = { x = 0, y = -50 },
            j = { x = 0, y = 50 },
          }
          for key, dir in pairs(dirs) do
            hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = dir }))
            hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
            hl.bind(mainMod .. " + CTRL + " .. key,
              hl.dsp.window.resize({ x = resize[key].x, y = resize[key].y, relative = true }))
          end

          for i = 1, 10 do
            local key = i % 10
            hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
            hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
          end

          hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
          hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

          hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
          hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

          -- flameshot: selection editor / monitor under the cursor; both save to
          -- ~/Pictures and copy to the clipboard. flameshot-select wraps
          -- `flameshot gui` to fix its capture overlay position (see flameshotSelect).
          hl.bind(mainMod .. " + SHIFT + s", hl.dsp.exec_cmd("flameshot-select"))
          hl.bind(mainMod .. " + SHIFT + Home", hl.dsp.exec_cmd("flameshot screen -c -p ~/Pictures"))

          hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
          hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
          hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
          hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
          hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s +5%"), { locked = true })
          hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { locked = true })

          hl.window_rule({
            name = "teamspeak-ws-2",
            match = { initial_class = "^(teamspeak-client)" },
            workspace = "2 silent",
            tile = true,
          })
          hl.window_rule({
            name = "discord-ws-2",
            match = { initial_class = "^(discord)$" },
            workspace = "2 silent",
            tile = true,
          })
          hl.window_rule({
            name = "spotify-ws-2",
            match = { initial_class = "^(spotify)" },
            workspace = "2 silent",
            tile = true,
          })
          hl.window_rule({
            name = "steam-ws-8",
            match = { initial_class = "^(steam)" },
            workspace = "8 silent",
          })
          hl.window_rule({
            name = "flameshot-float-top",
            match = { title = "^(flameshot)$" },
            float = true,
            pin = true,
          })
          hl.window_rule({
            name = "cider-ws-2",
            match = { initial_class = "^(cider)" },
            workspace = "2 silent",
            tile = true,
          })
        '';
      };
    };
}
