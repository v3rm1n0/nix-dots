{
  config,
  lib,
  pkgs,
  ...
}:
let
  colorScheme = config.userOptions.colorScheme;
in
{
  imports = [
    ./fonts
    ./gtk
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${colorScheme}.yaml";
    polarity = "dark";
  };
}
