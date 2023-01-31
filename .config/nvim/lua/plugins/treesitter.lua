return {
  { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true },

  {
    'nvim-treesitter/nvim-treesitter',
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
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      require('nvim-treesitter.install').compilers = { "clang" }
    end,
  },
}
