return {
  {
    'echasnovski/mini.bufremove',
    keys = {
      {
        'X',
        function()
          require('mini.bufremove').delete(0, false)
        end,
        desc = 'Delete Buffer',
      },
    },
  },

  {
    'echasnovski/mini.splitjoin',
    version = false,
    opts = {
      mappings = {
        toggle = 'gs',
      },
    },
  },

  {
    'echasnovski/mini.bracketed',
    version = false,
    opts = {
      -- Disable by setting suffix to empty
      buffer = { suffix = '' },
      diagnostic = { suffix = '' },
      oldfile = { suffix = '', options = {} },
      comment = { suffix = 'c', options = {} },
      conflict = { suffix = 'x', options = {} },
      file = { suffix = 'f', options = {} },
      indent = { suffix = 'i', options = {} },
      jump = { suffix = 'j', options = {} },
      location = { suffix = 'l', options = {} },
      quickfix = { suffix = 'q', options = {} },
      treesitter = { suffix = 't', options = {} },
      undo = { suffix = 'u', options = {} },
      window = { suffix = 'w', options = {} },
      yank = { suffix = '', options = {} },
    },
  },

  -- better text-objects
  {
    'echasnovski/mini.ai',
    lazy = false,
    keys = {
      { 'a', mode = { 'x', 'o' } },
      { 'i', mode = { 'x', 'o' } },
    },
    dependencies = { 'nvim-treesitter-textobjects' },
    opts = function()
      local ai = require('mini.ai')
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { '@conditional.outer', '@loop.outer' },
            i = { '@conditional.inner', '@loop.inner' },
          }, {}),
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
        },
      }
    end,
    config = function(_, opts)
      local ai = require('mini.ai')
      ai.setup(opts)
    end,
  },

  -- autopair
  {
    'echasnovski/mini.pairs',
    version = false,
    opts = {
      mappings = {
        ['('] = { action = 'open', pair = '()', neigh_pattern = '.[^%S]' },
        ['['] = { action = 'open', pair = '[]', neigh_pattern = '.[^%S]' },
        ['{'] = { action = 'open', pair = '{}', neigh_pattern = '.[^%S]' },

        [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
        [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
        ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

        ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '.[^%S]', register = { cr = false } },
        ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '.[^%S].', register = { cr = false } },
        ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '.[^%S]', register = { cr = false } },
      },
    },
  },

  {
    'echasnovski/mini.diff',
    enabled = false,
    version = false,
    opts = {
      view = {
        style = 'sign',
        signs = { add = '┃', change = '┃', delete = '▒' },
      },
      mappings = {
        goto_first = '',
        goto_prev = '',
        goto_next = '',
        goto_last = '',
      },
    },
    keys = {
      { '<Leader>gd', '<CMD>lua require("mini.diff").toggle_overlay()<CR>', desc = 'Toggle MiniDiff' },
    },
  },
}
