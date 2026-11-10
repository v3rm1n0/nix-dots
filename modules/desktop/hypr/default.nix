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
      inherit (config.userOptions) username;
      hyprPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
      # mesa must match the nixpkgs the upstream hyprland was built against
      hyprNixpkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      options.mods.desktop.hypr.enable =
        lib.mkEnableOption "the Hyprland desktop (hyprland, hyprlock, hyprpaper, polkit agent)";

      config = lib.mkIf config.mods.desktop.hypr.enable {
        environment.systemPackages = with pkgs; [
          brightnessctl
          gthumb
          hyprpaper
          libnotify
          nautilus
          networkmanagerapplet
          pavucontrol
          playerctl
          # nixpkgs passes "--prefix PATH : ..." as a single arg, which breaks makeWrapper under structuredAttrs
          (pywal.overridePythonAttrs {
            makeWrapperArgs = [
              "--prefix"
              "PATH"
              ":"
              (lib.makeBinPath [ imagemagick ])
            ];
          })
          satty
          wl-clipboard
          yazi
          zenity
        ];

        hardware.graphics.package = hyprNixpkgs.mesa;

        fonts.packages = [ pkgs.noto-fonts ];

        hjem.users.${username}.systemd.services.hyprpolkitagent = {
          description = "Hyprland Polkit Authentication Agent";
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];
          # graphical-session.target is shared with other sessions (sway), where this aborts.
          unitConfig.ConditionEnvironment = "XDG_CURRENT_DESKTOP=Hyprland";
          serviceConfig = {
            ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
            Restart = "on-failure";
          };
        };

        programs = {
          hyprland = {
            enable = true;
            package = hyprPkgs.hyprland;
            portalPackage = hyprPkgs.xdg-desktop-portal-hyprland;
            xwayland.enable = true;
            withUWSM = true;
          };

          nautilus-open-any-terminal = {
            enable = true;
            terminal = "ghostty";
          };
        };
      };
    };
}
