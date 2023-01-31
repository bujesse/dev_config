return {

  -- session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>sd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- library used by other plugins
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },

  -- window picker
  {
    's1n7ax/nvim-window-picker',
    version = 'v1.*',
    opts = {
      selection_chars = 'HLFJDKSA;CMRUEIWOQP',
      fg_color = '#DCD7BA',
      current_win_hl_color = '#C34043',
      other_win_hl_color = '#76946A',
      filter_rules = {
        -- filter using buffer options
        bo = {
          -- if the file type is one of following, the window will be ignored
          filetype = { 'neo-tree', "neo-tree-popup", "notify" },
          -- if the buffer type is one of following, the window will be ignored
          buftype = { 'terminal', "quickfix" },
        },
      },
    },
  },

}
