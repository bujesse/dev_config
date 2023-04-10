return {
  -- easily jump to any location and enhanced f/t motions for Leap
  {
    'ggandor/leap.nvim',
    keys = {
      {
        's',
        ":lua require('leap').leap({ target_windows = { vim.fn.win_getid() } })<CR>",
        mode = { 'n', 'x' },
        desc = 'Leap in current window',
      },
      {
        'S',
        function()
          require('leap').leap({
            target_windows = vim.tbl_filter(function(win)
              return vim.api.nvim_win_get_config(win).focusable
            end, vim.api.nvim_tabpage_list_wins(0)),
          })
        end,
        mode = { 'n', 'x' },
        desc = 'Leap in all windows',
      },
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
        -- Effectivley disable the highlight
        highlight = 10 ^ 7,
      },
    },
    config = function(_, opts)
      require('mini.jump').setup(opts)
    end,
    version = '*',
  },

  -- quick-scope
  {
    'unblevable/quick-scope',
    enabled = false,
    init = function()
      -- vim.g.qs_highlight_on_keys = { 'f', 'F', 't', 'T' }
      -- vim.cmd("let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']")
    end,
  },
}
