{ config, pkgs, ... }:
let
  username = config.userOptions.username;
in
{
  imports = [
    ./bash.nix
    ./p10k
    ./zsh.nix
  ];

  home-manager.users.${username} = {
    programs.git = {
      enable = true;
      settings = {
        push.autoSetupRemote = "true";
        user = {
          name = "V3RM1N";
          email = "mail@v3rm1n.dev";
        };
      };
      signing = {
        format = "openpgp";
        key = "04A465051516159B";
        signByDefault = true;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    acpi
    bat
    bat-extras.batman
    clang
    deadnix
    eza
    gh
    glow
    nixd
    nixfmt
    statix
    tirith
    unzip
    zoxide
  ];
}
