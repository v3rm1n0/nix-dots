_:
let
  luaModule =
    { pkgs, ... }:
    {
      runtimePkgs = [
        pkgs.lua-language-server
      ];

      specs.lua-language-server = {
        data = null;
        config = ''vim.lsp.enable("lua_ls")'';
      };
    };

  nixModule =
    { pkgs, ... }:
    {
      runtimePkgs = [
        pkgs.nixd
        pkgs.nixfmt
      ];
    };
in
{
  flake.modules.neovim = {
    lua = luaModule;
    nix = nixModule;

    # Use let-bound references instead of self.modules.neovim.* to avoid
    # circular evaluation through the flake.modules.neovim attrset
    allServers = {
      imports = [
        luaModule
        nixModule
      ];
    };
  };
}
