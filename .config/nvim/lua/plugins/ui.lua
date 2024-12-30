return {

  -- Better `vim.notify()`
  {
    'rcarriga/nvim-notify',
    enabled = false,
    keys = {
      {
        '<leader>un',
        function()
          require('notify').dismiss({ silent = true, pending = true })
        end,
        desc = 'Delete all Notifications',
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },

  -- better vim.ui
  {
    'stevearc/dressing.nvim',
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.input(...)
      end
    end,
  },

  -- bufferline
  {
    'akinsho/bufferline.nvim',
    enabled = false,
    event = 'VeryLazy',
    dependencies = {
      -- buffer remove
      {
        'echasnovski/mini.bufremove',
        -- stylua: ignore
        keys = {
          { "X", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
        },
      },
      'tiagovla/scope.nvim',
    },
    keys = {
      { 'L', '<Cmd>keepjumps BufferLineCycleNext<CR>', desc = 'Next buffer' },
      { 'H', '<Cmd>keepjumps BufferLineCyclePrev<CR>', desc = 'Prev buffer' },
      { '<C-Left>', '<Cmd>BufferLineMovePrev<CR>', desc = 'Move buffer prev' },
      { '<C-Right>', '<Cmd>BufferLineMoveNext<CR>', desc = 'Move buffer next' },
      { 'gb', '<Cmd>BufferLinePick<CR>', desc = 'Go to Buffer' },
      { '<Leader>bl', '<Cmd>BufferLineCloseRight<CR>', desc = 'Close all buffers right' },
      { '<Leader>bh', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Close all buffers left' },
      { '<Leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Pin buffer' },
      {
        '<Leader>bo',
        function()
          vim.cmd('BufferLineCloseRight')
          vim.cmd('BufferLineCloseLeft')
          vim.cmd('silent! only')
        end,
        desc = 'Close Other buffers',
      },
    },
    opts = {
      options = {
        always_show_bufferline = true,
        middle_mouse_command = function(bufnum)
          vim.cmd('bdelete! ' .. bufnum)
        end,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'Neo-tree',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
        separator_style = 'slant',
        persist_buffer_sort = true,
        max_name_length = 25,
        max_prefix_length = 20, -- prefix used when a buffer is de-duplicated
      },
    },
  },

  {
    'tiagovla/scope.nvim',
    config = true,
    keys = {
      { '<Leader>bm', '<CMD>ScopeMoveBuf<CR>', desc = 'Move Buffer to Tab' },
    },
  },

  {
    'romgrk/barbar.nvim',
    lazy = false,
    dependencies = {
      'kyazdani42/nvim-web-devicons',
      'tiagovla/scope.nvim',
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      animation = false,
      focus_on_close = 'left',
      icons = {
        diagnostics = {
          enabled = false,
        },
        -- modified = { separator = '⋄' },
        pinned = { button = '車', filename = true },
      },
      sidebar_filetypes = {
        ['neo-tree'] = { event = 'BufWipeout' },
        Outline = { event = 'BufWinLeave', text = 'symbols-outline' },
      },
    },
    keys = {
      { 'L', '<Cmd>keepjumps BufferNext<CR>', desc = 'Next buffer' },
      { 'H', '<Cmd>keepjumps BufferPrevious<CR>', desc = 'Prev buffer' },
      -- { ']b', '<Cmd>keepjumps BufferNext<CR>', desc = 'Next buffer' },
      -- { '[b', '<Cmd>keepjumps BufferPrevious<CR>', desc = 'Prev buffer' },
      { '<C-Left>', '<Cmd>BufferMovePrevious<CR>', desc = 'Move buffer prev' },
      { '<C-Right>', '<Cmd>BufferMoveNext<CR>', desc = 'Move buffer next' },
      { 'X', '<Cmd>BufferClose<CR>', desc = 'Close Buffer' },
      { '<Leader>br', '<Cmd>BufferRestore<CR>', desc = 'Restore Buffer' },
      { 'gb', '<Cmd>BufferPick<CR>', desc = 'Go to Buffer' },
      { '<Leader>bl', '<Cmd>BufferCloseBuffersRight<CR>', desc = 'Close all buffers right' },
      { '<Leader>bh', '<Cmd>BufferCloseBuffersLeft<CR>', desc = 'Close all buffers left' },
      { '<Leader>bp', '<Cmd>BufferPin<CR>', desc = 'Pin buffer' },
      {
        '<Leader>bo',
        '<Cmd>BufferCloseAllButVisible<CR>',
        desc = 'Close all but visible buffers',
      },
      {
        '<Leader>bO',
        '<Cmd>BufferCloseAllButCurrentOrPinned<CR>',
        desc = 'Close all but current/pinned',
      },
    },
  },

  -- indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    enabled = false,
    main = 'ibl',
    event = 'BufReadPost',
    opts = {
      exclude = {
        buftypes = { 'dashboard', 'terminal', 'nofile' },
        filetypes = {
          'help',
          'startify',
          'dashboard',
          'lazy',
          'neogitstatus',
          'NvimTree',
          'Trouble',
          'text',
        },
      },
      indent = {
        char = { '│', '¦' },
      },
      scope = {
        enabled = true,
        char = '▎',
        show_start = false,
        show_end = false,
      },
    },
  },

  -- icons
  {
    'kyazdani42/nvim-web-devicons',
    lazy = true,
    opts = {
      default = true,
    },
  },

  -- ui components
  {
    'MunifTanjim/nui.nvim',
  },

  -- smooth scroll
  {
    'karb94/neoscroll.nvim',
    enabled = false,
    config = function()
      local neoscroll = require('neoscroll')
      neoscroll.setup({
        mappings = {},
        easing = 'sine',
      })
      local keymap = {
        ['<C-u>'] = function()
          neoscroll.ctrl_u({ duration = 60 })
        end,
        ['<C-d>'] = function()
          neoscroll.ctrl_d({ duration = 60 })
        end,
      }
      local modes = { 'n', 'v', 'x' }
      for key, func in pairs(keymap) do
        vim.keymap.set(modes, key, func)
      end
    end,
  },

  -- colorizer
  -- {
  --   'NvChad/nvim-colorizer.lua',
  --   cmd = { 'ColorizerToggle' },
  --   keys = {
  --     { 'yoC', '<CMD>ColorizerToggle<CR>', desc = 'Toggle Colorizer' },
  --   },
  --   opts = {},
  -- },
  {
    'brenoprata10/nvim-highlight-colors',
    lazy = false,
    opts = {
      render = 'virtual',
    },
    keys = {
      { 'yoC', '<CMD>HighlightColors Toggle<CR>', desc = 'Toggle Colorizer' },
    },
  },
}
