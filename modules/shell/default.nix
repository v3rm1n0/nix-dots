{ pkgs, username, ... }:
{
  imports = [
    ./bash.nix
    ./p10k
    ./zsh.nix
  ];

  home-manager.users.${username} = {
    programs.git = {
      enable = true;
      userName = "V3RM1N";
      userEmail = "v3rm1n0@proton.me";
      signing = {
        key = "4998F4C236F92A36";
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
    nixd
    nixfmt-rfc-style
    unzip
    zoxide
  ];
}
