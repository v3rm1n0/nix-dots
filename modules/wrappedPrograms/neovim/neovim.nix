{
  inputs,
  self,
  lib,
  ...
}:
{
  imports = [ inputs.wrapper-modules.flakeModules.wrappers ];

  # Declare flake.modules as mergeable so lsp.nix can also contribute
  options.flake.modules = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.raw);
    default = { };
  };

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
            default = lib.generators.mkLuaInline "vim.uv.os_homedir() .. '/dotfiles/modules/wrappedPrograms/neovim'";
          };
        };
        config = {
          settings.config_directory = if config.dynamicMode then config.dynamicInitLua else config.initLua;

          extraPackages = [
            pkgs.ffmpeg-full
            pkgs.imagemagick
            pkgs.wl-clipboard
            pkgs.luarocks
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
        packages.neovim = inputs.wrapper-modules.wrappers.neovim.wrap {
          inherit pkgs;
          imports = [
            self.modules.neovim.main
            self.modules.neovim.lua
            self.modules.neovim.nix
          ];
        };

        packages.neovimFull = inputs.wrapper-modules.wrappers.neovim.wrap {
          inherit pkgs;
          imports = [
            self.modules.neovim.main
            self.modules.neovim.allServers
          ];
        };

        packages.neovimDynamic = inputs.wrapper-modules.wrappers.neovim.wrap {
          inherit pkgs;
          dynamicMode = true;
          imports = [
            self.modules.neovim.main
            self.modules.neovim.allServers
          ];
        };
      };
  };
}
