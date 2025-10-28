{
  config,
  lib,
  pkgs,
  ...
}:
let
  username = config.userOptions.username;
in
{
  home-manager.users.${username} = {
    stylix.targets.neovim.enable = false;
    programs.neovim = {
      enable = true;
      extraLuaPackages = ps: [ ps.magick ps.luarocks ];
      extraPackages = [ pkgs.imagemagick ];
    };
  };
}
