{
  config,
  pkgs,
  ...
}:
let
  dots = config.userOptions.dots;
  username = config.userOptions.username;
in
{
  imports = [
    ./btrfs.nix
    ./gc.nix
    ./settings.nix
  ];

  system = {
    autoUpgrade = {
      enable = true;
      flake = "${config.userOptions.dots}";
      flags = [
        "-L"
        "--upgrade"
      ];
      dates = "weekly";
    };
    systemBuilderCommands = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';
    stateVersion = "23.11";
  };

  nix = {
    package = pkgs.nixVersions.latest;
    nixPath = [ "nixpkgs=/run/current-system/nixpkgs/" ];
  };

  home-manager.users.${username} = {
    home.stateVersion = "23.11";
    nixpkgs.config.allowUnfree = true;
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "ghostty";
      };
    };
  };

  systemd.tpm2.enable = false;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nh = {
    enable = true;
    flake = "${dots}";
  };

  programs.nix-ld = {
    enable = true;
    libraries = (pkgs.steam-run.args.multiPkgs pkgs) ++ [
      pkgs.stdenv.cc.cc.lib
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "jitsi-meet-1.0.8792"
    ];
  };

  environment.systemPackages = with pkgs; [
    better-control
    sbctl
  ];
}
