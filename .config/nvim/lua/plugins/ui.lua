return {

  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Delete all Notifications",
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
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- bufferline
  {
    'akinsho/bufferline.nvim',
    event = "VeryLazy",
    dependencies = {
      -- buffer remove
      {
        "echasnovski/mini.bufremove",
        -- stylua: ignore
        keys = {
          { "X", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
        },
      },
      {
        -- Keep buffers in their own tabs
        'tiagovla/scope.nvim',
        config = true,
      }
    },
    keys = {
      { 'L', ':BufferLineCycleNext<CR>', desc = 'Next buffer' },
      { 'H', ':BufferLineCyclePrev<CR>', desc = 'Prev buffer' },
      { '<C-Left>', ':BufferLineMovePrev<CR>', desc = 'Move buffer prev' },
      { '<C-Right>', ':BufferLineMoveNext<CR>', desc = 'Move buffer next' },
      { 'gb', ':BufferLinePick<CR>', desc = 'Go to Buffer' },
      { '<Leader>bl', ':BufferLineCloseRight<CR>', desc = 'Close all buffers right' },
      { '<Leader>bh', ':BufferLineCloseLeft<CR>', desc = 'Close all buffers left' },
      { '<Leader>bp', ':BufferLineTogglePin<CR>', desc = 'Pin buffer' },
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
        persist_buffer_sort = true,
        max_name_length = 25,
        max_prefix_length = 20, -- prefix used when a buffer is de-duplicated
      },
    },
  },

  -- indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufReadPost',
    opts = {
      buftype_exclude = { 'dashboard', 'terminal', 'nofile' },
      -- char_list = { '│', '¦' },
      -- char = '▏',
      -- context_char = '▏',
      show_trailing_blankline_indent = false,
      show_first_indent_level = false,
      show_current_context = true,
      show_current_context_start = false,
      filetype_exclude = {
        'help',
        'startify',
        'dashboard',
        'lazy',
        'neogitstatus',
        'NvimTree',
        'Trouble',
        'text',
      },
    }
  },

  -- icons
  {
    'kyazdani42/nvim-web-devicons',
    lazy = true,
    opts = {
      default = true,
    }
  },

  -- ui components
  {
    'MunifTanjim/nui.nvim',
  },

  -- smooth scroll
  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup({
        mappings = {},
      })
      local t = {}
      t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '55', 'sine' } }
      t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '55', 'sine' } }
      require('neoscroll.config').set_mappings(t)
    end
  },

  -- colorizer
  {
    'NvChad/nvim-colorizer.lua',
    config = true,
  },
}