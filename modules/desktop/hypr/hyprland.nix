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

      monitorLine =
        m:
        let
          r = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
          p = "${toString m.x}x${toString m.y}";
        in
        if m.enabled then
          "hl.monitor({ output = \"${m.name}\", mode = \"${r}\", position = \"${p}\", scale = \"auto\" })"
        else
          "hl.monitor({ output = \"${m.name}\", disable = true })";

      monitorsLua = lib.concatMapStrings (m: monitorLine m + "\n") config.monitors;

      workspaceLine =
        monitor: workspace:
        "hl.workspace_rule({ workspace = \"${toString workspace}\", monitor = \"${monitor.name}\"${
          lib.optionalString (workspace == monitor.workspacePrimary) ", default_workspace = true"
        } })";

      workspacesLua =
        lib.concatStringsSep "\n" (
          builtins.concatLists (map (monitor: map (workspaceLine monitor) monitor.workspaces) config.monitors)
          ++ [ "hl.workspace_rule({ workspace = \"2\", layout_opts = { split = \"v\" } })" ]
        )
        + "\n";
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

      hjem.users.${username}.files.".config/hypr/hyprland.lua" = {
        text = ''
          ${monitorsLua}
          ${workspacesLua}
          hl.config({
            general = {
              gaps_in     = 5,
              gaps_out    = 10,
              border_size = 2,
              layout      = "dwindle",
              col = {
                active_border   = "rgb(${colors.base0D})",
                inactive_border = "rgb(${colors.base03})",
              },
            },
            decoration = {
              rounding       = 20,
              rounding_power = 2,
              blur = {
                enabled  = true,
                size     = 3,
                passes   = 2,
                vibrancy = 0.1696,
              },
              shadow = {
                enabled      = true,
                range        = 4,
                render_power = 3,
              },
            },
            animations = {
              enabled = true,
            },
            input = {
              kb_layout          = "us, de",
              follow_mouse       = 1,
              numlock_by_default = true,
              touchpad = {
                natural_scroll = false,
              },
            },
            misc = {
              disable_hyprland_logo = true,
            },
            dwindle = {
              split_width_multiplier = 1.35,
              pseudotile             = true,
            },
            ecosystem = {
              no_update_news = true,
            },
          })

          hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

          hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
          hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
          hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
          hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
          hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
          hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })

          local mainMod = "ALT_L"

          hl.bind(mainMod .. " + T",     hl.dsp.exec_cmd("ghostty"))
          hl.bind("SHIFT + ALT_L + Q",   hl.dsp.window.close())
          hl.bind(mainMod .. " + M",     hl.dsp.exit())
          hl.bind(mainMod .. " + E",     hl.dsp.exec_cmd("nautilus"))
          hl.bind(mainMod .. " + V",     hl.dsp.window.float({ action = "toggle" }))
          hl.bind(mainMod .. " + P",     hl.dsp.window.pseudo())
          hl.bind("SUPER + ALT_L + L",   hl.dsp.exec_cmd("hyprlock"))
          hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("vicinae toggle"))
          hl.bind(mainMod .. " + R",     hl.dsp.exec_cmd("${config.userOptions.browser}"))

          hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
          hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
          hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
          hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

          hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
          hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
          hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
          hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

          hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.resize({ x = -50, y = 0,   relative = true }))
          hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.resize({ x = 50,  y = 0,   relative = true }))
          hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.resize({ x = 0,   y = -50, relative = true }))
          hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }))

          for i = 1, 10 do
            local key = i % 10
            hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
            hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
          end

          hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
          hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

          hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
          hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

          hl.bind(mainMod .. " + SHIFT + s",
            hl.dsp.exec_cmd([[wayfreeze & sleep 0.2 && grim -g "$(slurp)" - | tee ~/Pictures/$(date +%Y%m%d_%H%M%S).png | wl-copy; kill %1]]))
          hl.bind(mainMod .. " + SHIFT + Home",
            hl.dsp.exec_cmd([[grim -g "$(hyprctl monitors -j | jq -r '.[] | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)" - | tee ~/Pictures/$(date +%Y%m%d_%H%M%S).png | wl-copy]]))

          hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
          hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
          hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),       { locked = true })
          hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),     { locked = true })
          hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s +5%"),                              { locked = true })
          hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"),                              { locked = true })

          hl.window_rule({
            name      = "teamspeak-ws-2",
            match     = { initial_class = "^(teamspeak-client)" },
            workspace = "2 silent",
            tile      = true,
          })

          hl.window_rule({
            name      = "discord-ws-2",
            match     = { initial_class = "^(equibop)$" },
            workspace = "2 silent",
            tile      = true,
          })

          hl.window_rule({
            name      = "spotify-ws-2",
            match     = { initial_class = "^(spotify)" },
            workspace = "2 silent",
            tile      = true,
          })

          hl.window_rule({
            name      = "steam-ws-8",
            match     = { initial_class = "^(steam)" },
            workspace = "8 silent",
          })

          hl.on("hyprland.start", function()
            hl.exec_cmd("noctalia-shell")
            hl.exec_cmd("TeamSpeak")
          end)
        '';
      };
    };
}
