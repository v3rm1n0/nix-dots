{ ... }:
let
  luaModule =
    { pkgs, ... }:
    {
      extraPackages = [
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
      extraPackages = [
        pkgs.nixd
        pkgs.nixfmt
      ];
    };
in
{
  flake.nixosModules.neovim.lua = luaModule;
  flake.nixosModules.neovim.nix = nixModule;

  # Use let-bound references instead of self.modules.neovim.* to avoid
  # circular evaluation through the flake.modules.neovim attrset
  flake.modules.neovim.allServers = {
    imports = [
      luaModule
      nixModule
    ];
  };
}
