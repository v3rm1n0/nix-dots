require("sshfs").setup({
  connections = {
    ssh_configs = {                 -- Table of ssh config file locations to use
      "~/.ssh/config",
    },
    sshfs_options = {
      reconnect = true,             -- Auto-reconnect on connection loss
      ConnectTimeout = 5,           -- Connection timeout in seconds
      compression = "yes",          -- Enable compression
      ServerAliveInterval = 15,     -- Keep-alive interval (15s × 3 = 45s timeout)
      ServerAliveCountMax = 3,      -- Keep-alive message count
      dir_cache = "yes",            -- Enable directory caching
      dcache_timeout = 300,         -- Cache timeout in seconds
      dcache_max_size = 10000,      -- Max cache size
    },
    control_persist = "10m",        -- How long to keep ControlMaster connection alive after last use
    socket_dir = vim.fn.expand("$HOME/.ssh/sockets"), -- Directory for ControlMaster sockets
  },
  mounts = {
    base_dir = vim.fn.expand("$HOME") .. "/mnt", -- where remote mounts are created
  },
  hooks = {
    on_exit = {
      auto_unmount = true,        -- auto-disconnect all mounts on :q or exit
      clean_mount_folders = true, -- optionally clean up mount folders after disconnect
    },
    on_mount = {
      auto_change_to_dir = false, -- auto-change current directory to mount point
      auto_run = "find",          -- "find" (default), "grep", "live_find", "live_grep", "terminal", "none", or a custom function(ctx)
    },
  },
  ui = {
    file_picker = {
      preferred_picker = "nvim-tree",  -- one of: "auto", "snacks", "fzf-lua", "mini", "telescope", "oil", "neo-tree", "nvim-tree", "yazi", "lf", "nnn", "ranger", "netrw"
      fallback_to_netrw = true,   -- fallback to netrw if no picker is available
      netrw_command = "Explore",  -- netrw command: "Explore", "Lexplore", "Sexplore", "Vexplore", "Texplore"
    },
    remote_picker = {
      preferred_picker = "auto",  -- one of: "auto", "snacks", "fzf-lua", "telescope", "mini"
    },
  },
  lead_prefix = "<leader>m",      -- change keymap prefix (default: <leader>m)
  keymaps = {
    mount = "<leader>mm",         -- creates an ssh connection and mounts via sshfs
    unmount = "<leader>mu",       -- disconnects an ssh connection and unmounts via sshfs
    unmount_all = "<leader>mU",   -- disconnects all ssh connections and unmounts via sshfs
    explore = "<leader>me",       -- explore an sshfs mount using your native editor
    change_dir = "<leader>md",    -- change dir to mount
    command = "<leader>mo",       -- run command on mount
    config = "<leader>mc",        -- edit ssh config
    reload = "<leader>mr",        -- manually reload ssh config
    files = "<leader>mf",         -- browse files using chosen picker
    grep = "<leader>mg",          -- grep files using chosen picker
    terminal = "<leader>mt",      -- open ssh terminal session
  },
})
