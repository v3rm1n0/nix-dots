_: {
  flake.modules.nixos."host/Template" = {
    nixpkgs.hostPlatform = "x86_64-linux";

    userOptions = {
      colorScheme = "gruvbox-dark-hard";
      dots = "/etc/dotfiles";
      hostName = "Template";
    };
  };
}
