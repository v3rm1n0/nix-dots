require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>e", function()
  local api = require("nvim-tree.api")
  if vim.bo.filetype == "NvimTree" then
    vim.cmd("wincmd p") -- go back to previous window
  else
    api.tree.focus()
  end
end, { desc = "toggle focus nvimtree" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
