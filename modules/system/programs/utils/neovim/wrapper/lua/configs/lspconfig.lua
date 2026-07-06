require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "nixd" }
vim.lsp.enable(servers)

vim.lsp.config("nixd", {
  cmd = { "nixd" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", ".git" },
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "nixfmt" }, -- or nixfmt or nixpkgs-fmt
      },
      options = {
        nixos = {
          expr = '(builtins.getFlake "/home/v3rm1n/.dotfiles").nixosConfigurations',
        },
        home_manager = {
          expr = '(builtins.getFlake "/home/v3rm1n/.dotfiles").nixosConfigurations.Desktop.options.home-manager.users.type.getSubOptions []'
        }
      },
    },
  },
})
-- read :h vim.lsp.config for changing options of lsp servers
