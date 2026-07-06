return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
      },
    },
  },

  {
    "vyfor/cord.nvim",
    build = ":Cord update",
    event = "VeryLazy",
  },

  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    priority = 49,
    opts = {
      preview = {
        hybrid_modes = { "i" },
      },
    },
  },

  {
    "lervag/vimtex",
    lazy = false, -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_view_forward_search_on_start = false
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = "/home/v3rm1n/.texfiles/",
        out_dir = "/home/v3rm1n/.texfiles/",
      }
    end,
  },

  {
    "3rd/image.nvim",
    lazy = false,
    build = false,
    opts = {
      processor = "magick_cli",
    },
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          enabled = false,
        },
      },
      label = {
        uppercase = false,
        rainbow = {
          enabled = true,
        },
      },
    },
    keys = {
      {
        "f",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "F",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },

  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true, -- if you want to enable the plugin
      message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
      date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
      virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
    },
  },
}
