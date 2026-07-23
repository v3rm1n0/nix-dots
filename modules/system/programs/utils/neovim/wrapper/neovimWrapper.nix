{
  inputs,
  self,
  ...
}:
{
  imports = [ inputs.wrapper-modules.flakeModules.wrappers ];

  config = {
    flake.modules.neovim.main =
      {
        config,
        wlib,
        lib,
        pkgs,
        ...
      }:
      {
        options = {
          dynamicMode = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              If true, use impure config instead for fast edits

              Both versions of the package may be installed simultaneously
            '';
          };
          initLua = lib.mkOption {
            type = wlib.types.stringable;
            default = ./.;
          };
          dynamicInitLua = lib.mkOption {
            type = lib.types.either wlib.types.stringable lib.types.luaInline;
            default = lib.generators.mkLuaInline "vim.uv.os_homedir() .. '/dotfiles/modules/system/programs/utils/neovim/wrapper'";
          };
        };
        config = {
          settings.config_directory = if config.dynamicMode then config.dynamicInitLua else config.initLua;

          runtimePkgs = [
            pkgs.ffmpeg-full
            pkgs.imagemagick
            pkgs.wl-clipboard
            pkgs.luarocks
            pkgs.sshfs
          ];

          specs.init = {
            data = null;
            before = [ "MAIN_INIT" ];
            config = "require('init')";
          };

          specs.plugins = {
            data = [
              pkgs.vimPlugins.nvim-treesitter.withAllGrammars
            ];
          };
        };
      };

    perSystem =
      {
        pkgs,
        self',
        ...
      }:
      {
        packages = {
          neovim = inputs.wrapper-modules.wrappers.neovim.wrap {
            inherit pkgs;
            imports = [
              self.modules.neovim.main
              self.modules.neovim.lua
              self.modules.neovim.nix
            ];
          };

          neovimFull = inputs.wrapper-modules.wrappers.neovim.wrap {
            inherit pkgs;
            imports = [
              self.modules.neovim.main
              self.modules.neovim.allServers
            ];
          };

          neovimDynamic = inputs.wrapper-modules.wrappers.neovim.wrap {
            inherit pkgs;
            dynamicMode = true;
            imports = [
              self.modules.neovim.main
              self.modules.neovim.allServers
            ];
          };
        };
      };
  };
}
