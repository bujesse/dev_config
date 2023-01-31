return {
  { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true },

  -- Treesitter actions. Toggle booleans, quotes, conditionals,
  {
    'ckolkey/ts-node-action',
    dependencies = { 'nvim-treesitter', },
    config = true,
    keys = {
      {
        'ga',
        function()
          require("ts-node-action").node_action()
        end,
        desc = 'Trigger Node Action',
      },
    }
  },

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    version = false,
    event = 'BufReadPost',
    build = ':TSUpdate',
    keys = {
      { "<Cr>", desc = "Increment selection" },
      { "<bs>", desc = "Schrink selection", mode = "x" },
    },
    ---@type TSConfig
    opts = {
      highlight = { enable = true, },
      indent = { enable = true, },
      context_commentstring = { enable = true, enable_autocmd = false },
      ensure_installed = {
        'python',
        'bash',
        'fish',
        'lua',
        'vim',
        'tsx',
        'json',
        'yaml',
        'html',
        'scss',

        'toml',
        'rust',
        "regex",

        'javascript',
        'typescript',
        'vue',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Cr>",
          node_incremental = "<Cr>",
          scope_incremental = "<nop>",
          node_decremental = "<bs>",
        },
        is_supported = function()
          -- disable for command history window
          local mode = vim.api.nvim_get_mode().mode
          if mode == "c" then
            return false
          end
          return true
        end
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = { query = "@function.outer", desc = "Next Method start" },
            ["]]"] = { query = "@class.outer", desc = "Next Class start" },
            --
            -- You can use regex matching and/or pass a list in a "query" key to group multiple queires.
            ["]o"] = "@loop.*",
            -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
          },
          goto_next_end = {
            ["]M"] = { query = "@function.outer", desc = "Next Method end" },
            ["]["] = { query = "@class.outer", desc = "Next Class end" },
          },
          goto_previous_start = {
            ["[m"] = { query = "@function.outer", desc = "Prev Method start" },
            ["[["] = { query = "@class.outer", desc = "Prev Class start" },
          },
          goto_previous_end = {
            ["[M"] = { query = "@function.outer", desc = "Prev Method end" },
            ["[]"] = { query = "@class.outer", desc = "Prev Class end" },
          },
          -- Below will go to either the start or the end, whichever is closer.
          -- Use if you want more granular movements
          -- Make it even more gradual by adding multiple queries and regex.
          goto_next = {
            ["]o"] = { query = { "@block.outer", "@conditional.outer", "@loop.outer" }, desc = "Next block" },
          },
          goto_previous = {
            ["[o"] = { query = { "@block.outer", "@conditional.outer", "@loop.outer" }, desc = "Prev block" },
          }
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      require('nvim-treesitter.install').compilers = { "clang" }
    end,
  },
}
