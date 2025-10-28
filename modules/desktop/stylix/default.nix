{
  config,
  pkgs,
  ...
}:
let
  colorScheme = config.userOptions.colorScheme;
  username = config.userOptions.username;
in
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${colorScheme}.yaml";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 25;
    };
    fonts = {
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      monospace = {
        package = pkgs.nerd-fonts.geist-mono;
        name = "Geist Mono";
      };
      sansSerif = {
        package = pkgs.geist-font;
        name = "Geist";
      };
      serif = config.stylix.fonts.sansSerif;
      sizes = {
        applications = 12;
        desktop = 10;
        popups = 10;
        terminal = 10;
      };
    };
    polarity = "dark";
  };

  home-manager.users.${username} = {
    stylix = {
      icons = {
        enable = true;
        package = pkgs.kora-icon-theme;
        dark = "kora";
      };
      opacity.applications = 0.8;
      polarity = "dark";
    };
  };
}
