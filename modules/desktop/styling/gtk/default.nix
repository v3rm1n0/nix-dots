{
  config,
  pkgs,
  ...
}:
let
  username = config.userOptions.username;
in
{
  home-manager.users.${username} = _: {
    home.pointerCursor = {
      package = pkgs.bibata-cursors; # pkgs.adwaita-icon-theme;
      name = "Bibata-Modern-Ice"; # "Adwaita";
    };
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.kora-icon-theme;
        name = "kora";
      };
      cursorTheme = {
        package = pkgs.bibata-cursors; # pkgs.adwaita-icon-theme;
        name = "Bibata-Modern-Ice"; # "Adwaita";
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    };
  };
}
