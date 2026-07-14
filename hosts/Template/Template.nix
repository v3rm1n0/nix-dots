_: {
  flake.modules.nixos."host/Template" = {
    nixpkgs.hostPlatform = "x86_64-linux";

    userOptions = {
      browser = "librewolf";
      colorScheme = "gruvbox-dark-hard";
      dots = "/home/v3rm1n/dotfiles";
      hostName = "Template";
      username = "v3rm1n";
      wallpaper = "rocket.png";
    };
  };
}
