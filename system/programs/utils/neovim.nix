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
    stylix.targets.neovim.enable = lib.mkForce false;
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraLuaPackages = ps: [
        ps.magick
        ps.luarocks
      ];
      extraPackages = [ pkgs.imagemagick ];

      extraConfig = ''
        luafile ~/.config/nvim/init-nonnix.lua
      '';
    };
  };
}
