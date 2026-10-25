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

      onOff = b: if b then "on" else "off";

      # noctalia gets its own config home under sway, without the audio
      # visualizer: it redraws the bar at 60Hz while audio plays, and every
      # redraw makes swayfx recomposite the output (~25% sway CPU).
      noctalia = config.hjem.users.${username}.programs.noctalia;
      noctaliaHome = "/home/${username}/.config/noctalia-sway";
      noctaliaSettings = lib.recursiveUpdate noctalia.settings {
        bar.main.start = lib.remove "audio_visualizer" noctalia.settings.bar.main.start;
      };
      noctaliaToml =
        let
          raw = (pkgs.formats.toml { }).generate "config.toml" noctaliaSettings;
        in
        pkgs.runCommand "noctalia-sway-config" { } ''
          ${lib.getExe noctalia.package} config validate ${raw}
          cp ${raw} $out
        '';

      # NOTE: hyprland's `cm` (color management preset) has no sway equivalent
      # and is dropped.
      outputs = map (
        m:
        if m.enabled then
          "output ${m.name} mode ${toString m.width}x${toString m.height}@${toString m.refreshRate}Hz pos ${toString m.x} ${toString m.y} scale ${toString m.scale} adaptive_sync ${onOff (m.vrr != 0)} render_bit_depth ${toString m.bitdepth}"
        else
          "output ${m.name} disable"
      ) config.mods.desktop.monitors;

      workspaces = lib.concatMap (
        m: map (ws: "workspace ${toString ws} output ${m.name}") m.workspaces
      ) config.mods.desktop.monitors;

      # Focus each monitor's primary workspace on startup (hyprland's default:true).
      primaryWorkspaces = map (
        m: "exec swaymsg 'focus output ${m.name}; workspace number ${toString m.workspacePrimary}'"
      ) (lib.filter (m: m.enabled) config.mods.desktop.monitors);

      # $mod .. key focus/move bindings for workspaces 1-10 (key 0 for 10).
      workspaceBinds = lib.concatMap (
        i:
        let
          key = if i == 10 then "0" else toString i;
        in
        [
          "bindsym $mod+${key} workspace number ${toString i}"
          "bindsym $mod+Shift+${key} move container to workspace number ${toString i}"
        ]
      ) (lib.range 1 10);

      # Hyprland's initial_class matches both native Wayland app_ids and
      # XWayland classes; sway splits these, so emit a rule for each.
      byClass = re: rule: [
        "${rule} [app_id=\"${re}\"]"
        "${rule} [class=\"${re}\"]"
      ];

      ws2 = re: [
        (map (r: "${r} workspace number 2") (byClass re "assign"))
        (map (r: "${r} floating disable") (byClass re "for_window"))
      ];

      windowRules = lib.flatten [
        (ws2 "^(teamspeak-client)")
        (ws2 "^(equibop)$")
        (ws2 "^(spotify)")
        (map (r: "${r} workspace number 8") (byClass "^(steam)" "assign"))
        "for_window [title=\"^(flameshot)$\"] floating enable, sticky enable"
      ];

      lines =
        lib.flatten [
          "set $mod Mod4"
          "include /etc/sway/config.d/*"

          outputs
          workspaces

          # general
          "gaps inner 5"
          # sway adds inner gaps to outer ones; 5 + 5 matches hyprland's gaps_out = 10.
          "gaps outer 5"
          "default_border pixel 2"
          "default_floating_border pixel 2"
          "client.focused #${colors.base0D} #${colors.base0D} #${colors.base05} #${colors.base0D} #${colors.base0D}"
          "client.focused_inactive #${colors.base03} #${colors.base03} #${colors.base05} #${colors.base03} #${colors.base03}"
          "client.unfocused #${colors.base03} #${colors.base03} #${colors.base05} #${colors.base03} #${colors.base03}"

          # decoration (swayfx)
          # No blur: on nvidia it leaves smeared blocks behind translucent
          # windows (xray mode and 8-bit rendering don't help).
          "corner_radius 20"
          "shadows enable"
          "shadow_blur_radius 4"

          # input
          "input type:keyboard {"
          "  xkb_layout us,de"
          "  xkb_numlock enabled"
          "}"
          "input type:touchpad natural_scroll disabled"
          "focus_follows_mouse yes"

          # dwindle-style spiral tiling
          "exec_always autotiling-rs"

          "exec env NOCTALIA_CONFIG_HOME=${noctaliaHome} noctalia"
          "exec equibop"
          primaryWorkspaces

          "bindsym $mod+t exec ghostty"
          "bindsym $mod+Shift+q kill"
          "bindsym $mod+m exit"
          "bindsym $mod+e exec nautilus"
          "bindsym $mod+v floating toggle"
          "bindsym Ctrl+Shift+l exec hyprlock"
          "bindsym $mod+space exec vicinae toggle"
          "bindsym $mod+r exec ${browser}"

          "bindsym $mod+h focus left"
          "bindsym $mod+l focus right"
          "bindsym $mod+k focus up"
          "bindsym $mod+j focus down"

          "bindsym $mod+Shift+h move left"
          "bindsym $mod+Shift+l move right"
          "bindsym $mod+Shift+k move up"
          "bindsym $mod+Shift+j move down"

          "bindsym $mod+Ctrl+h resize shrink width 50px"
          "bindsym $mod+Ctrl+l resize grow width 50px"
          "bindsym $mod+Ctrl+k resize shrink height 50px"
          "bindsym $mod+Ctrl+j resize grow height 50px"

          "bindsym --whole-window $mod+button5 workspace next_on_output"
          "bindsym --whole-window $mod+button4 workspace prev_on_output"
        ]
        ++ workspaceBinds
        ++ [
          # flameshot-select only works around hyprland's floating re-centering,
          # so plain `flameshot gui` is enough here.
          "bindsym $mod+Shift+s exec flameshot gui -c -p ~/Pictures"
          "bindsym $mod+Shift+Home exec flameshot screen -c -p ~/Pictures"

          # left drag moves, right drag resizes
          "floating_modifier $mod normal"

          "bindsym --locked XF86AudioRaiseVolume exec wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
          "bindsym --locked XF86AudioLowerVolume exec wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
          "bindsym --locked XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          "bindsym --locked XF86AudioMicMute exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          "bindsym --locked XF86MonBrightnessUp exec brightnessctl s +5%"
          "bindsym --locked XF86MonBrightnessDown exec brightnessctl s 5%-"
        ]
        ++ windowRules;
    in
    {
      options.mods.desktop.sway.enable =
        lib.mkEnableOption "the Sway desktop (swayfx, ported from the Hyprland config without animations)";

      config = lib.mkIf config.mods.desktop.sway.enable {
        programs.sway = {
          enable = true;
          # swayfx provides the rounding/shadows from hyprland's decoration block.
          package = pkgs.swayfx;
          wrapperFeatures.gtk = true;
          extraOptions = lib.optional (lib.elem "nvidia" config.services.xserver.videoDrivers) "--unsupported-gpu";
          # The hypr module exports these globally; override them for this session.
          extraSessionCommands = ''
            export XDG_CURRENT_DESKTOP=sway
            export XDG_SESSION_DESKTOP=sway
            export WLR_NO_HARDWARE_CURSORS=1
          '';
        };

        environment.systemPackages = with pkgs; [
          autotiling-rs
          brightnessctl
          nautilus
          wl-clipboard
        ];

        hjem.users.${username} = {
          files = {
            ".config/sway/config".text = lib.concatLines lines;
            ".config/noctalia-sway/noctalia/config.toml".source = noctaliaToml;
          }
          // lib.mapAttrs' (
            name: palette:
            lib.nameValuePair ".config/noctalia-sway/noctalia/palettes/${name}.json" {
              source = (pkgs.formats.json { }).generate "${name}-palette.json" palette;
            }
          ) noctalia.customPalettes;

          # hyprpolkitagent only runs under Hyprland.
          systemd.services.polkit-gnome-agent = {
            description = "GNOME Polkit Authentication Agent (sway)";
            after = [ "graphical-session.target" ];
            partOf = [ "graphical-session.target" ];
            wantedBy = [ "graphical-session.target" ];
            unitConfig.ConditionEnvironment = "XDG_CURRENT_DESKTOP=sway";
            serviceConfig = {
              ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
              Restart = "on-failure";
            };
          };
        };
      };
    };
}
