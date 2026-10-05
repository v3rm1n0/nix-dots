require("zk").setup {
  picker = "telescope",
  lsp = {
    config = {
      name = "zk",
      cmd = { "zk", "lsp" },
      filetypes = { "markdown" },
      on_attach = function(_, bufnr)
        local opts = function(desc)
          return { buffer = bufnr, desc = desc }
        end
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts "zk follow link")
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts "zk references")
      end,
    },
    auto_attach = {
      enabled = true,
      filetypes = { "markdown" },
    },
  },
}

local map = vim.keymap.set

map("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", { desc = "zk new note" })
map("n", "<leader>zs", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", { desc = "zk search notes" })
map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", { desc = "zk backlinks" })
map("n", "<leader>zl", "<Cmd>ZkLinks<CR>", { desc = "zk outgoing links" })
map("n", "<leader>zd", "<Cmd>ZkNew { dir = 'journal/daily' }<CR>", { desc = "zk daily note" })
map("v", "<leader>zn", ":ZkNewFromTitleSelection<CR>", { desc = "zk new note from selection (title)" })
map(
  "v",
  "<leader>zc",
  ":ZkNewFromContentSelection { title = vim.fn.input('Title: ') }<CR>",
  { desc = "zk new note from selection (content)" }
)
