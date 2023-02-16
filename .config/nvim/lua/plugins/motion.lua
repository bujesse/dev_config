return {
  -- easily jump to any location and enhanced f/t motions for Leap
  {
    'ggandor/leap.nvim',
    keys = {
      { 's', ":lua require('leap').leap({ target_windows = { vim.fn.win_getid() } })<CR>", mode = { 'n', 'x' } },
    },
    event = 'VeryLazy',
    opts = {
      -- safe_labels = {},
      labels = {
        'j',
        'f',
        'k',
        'd',
        'l',
        's',
        'a',
        'e',
        'w',
        'o',
        'u',
        'r',
        'n',
        'v',
        'm',
        'c',
        'x',
        'z',
        '/',
        'p',
        'q',
        'g',
        'h',
        'J',
        'F',
        'K',
        'D',
        'L',
        'S',
        'A',
      },
    },
    config = function(_, opts)
      local leap = require('leap')
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
    end,
  },

  -- better f/t
  {
    'echasnovski/mini.jump',
    lazy = false,
    opts = {
      delay = {
        highlight = 0,
      },
    },
    config = function(_, opts)
      require('mini.jump').setup(opts)
    end,
    version = '*',
  },

  -- readline mappings for insert, command and search modes
  {
    'linty-org/readline.nvim',
    keys = function()
      local readline = require 'readline'
      return {
        { '<C-a>', '<C-o>I', mode = 'i' },
        { '<C-a>', readline.beginning_of_line, mode = '!' },
        { '<C-e>', readline.end_of_line, mode = '!' },
        { '<C-k>', readline.kill_line, mode = '!' },
        { '<C-u>', readline.backward_kill_line, mode = '!' }
      }
    end
  },
}
