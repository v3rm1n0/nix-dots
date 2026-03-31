{ inputs, ... }:
{
  flake.nixosModules.coreProgramsUtilsNeovim =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
    in
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
      ];
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
    };
}
