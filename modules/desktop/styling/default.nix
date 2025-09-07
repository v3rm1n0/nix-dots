{ pkgs, ... }:
{
  imports = [
    ./fonts
    ./gtk
    #./qt
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    polarity = "dark";
  };
}
