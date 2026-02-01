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
      settings.user = {
        name = "V3RM1N";
        email = "mail@v3rm1n.dev";
      };
      signing = {
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
    eza
    gh
    glow
    nixd
    nixfmt
    unzip
    zoxide
  ];
}
