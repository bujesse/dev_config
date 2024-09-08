return {
  -- snippets
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'rafamadriz/friendly-snippets',
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = 'TextChanged',
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
    config = function()
      require('luasnip/loaders/from_vscode').load({ paths = { CONFIG_PATH .. '/snippets' } })
    end,
  },

  -- auto completion
  {
    'onsails/lspkind-nvim',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/nvim-cmp',
    },
  },

  -- surround
  {
    'kylechui/nvim-surround',
    -- version = '*', -- Use for stability; omit to use `main` branch for the latest features
    opts = {
      aliases = {
        ['q'] = { '"', "'", '`' },
        ['b'] = { ')', '}', ']' },
      },
      keymaps = {
        insert = '<C-g>s',
        insert_line = '<C-g>S',
        normal = 'ys',
        normal_cur = 'yss',
        normal_line = 'yS',
        normal_cur_line = 'ySS',
        visual = 'S',
        visual_line = 'gS',
        delete = 'ds',
        change = 'cs',
        change_line = 'cS',
      },
      -- move_cursor = false,
    },
    config = function(_, opts)
      require('nvim-surround').setup(opts)
      vim.api.nvim_del_keymap('i', '<C-g>s')
      vim.api.nvim_del_keymap('i', '<C-g>S')
    end,
  },

  -- comments
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        -- Required for nvim-ts-context-commentstring
        pre_hook = function()
          return vim.bo.commentstring
        end,
        ignore = '^$',
        toggler = {
          block = 'gC',
        },
        opleader = {
          block = 'gC',
        },
      })
    end,
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
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {
      check_ts = false,
      enable_check_bracket_line = false,
      map_c_h = false, -- Map the <C-h> key to delete a pair
      map_c_w = false, -- map <c-w> to delete a pair if possible
      fast_wrap = {
        map = '<M-l>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = '$',
        before_key = 'h',
        after_key = 'l',
        cursor_pos_before = true,
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        manual_position = true,
        highlight = 'Search',
        highlight_grey = 'Comment',
      },
    },
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },

  {
    'altermo/ultimate-autopair.nvim',
    enable = false,
    event = { 'InsertEnter', 'CmdlineEnter' },
    -- branch = 'v0.6',
    opts = {
      fastwarp = {
        faster = true,
        map = '<A-l>',
        rmap = '<A-h>',
        nocursormove = false,
      },
      tabout = {
        enable = true,
        map = "<A-'>", --string or table
        cmap = "<A-'>", --string or table
        hopout = true,
        -- (|) > tabout > ()|
      },
    },
  },

  -- guess indent
  {
    'nmac427/guess-indent.nvim',
    opts = {},
  },

  -- refactoring
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    keys = {
      { '<leader>Rf', ':Refactor extract ', mode = { 'x' }, desc = 'Refactor extract to function' },
      { '<leader>RF', ':Refactor extract_to_file ', mode = { 'x' }, desc = 'Refactor extract_to_file' },
      { '<leader>Re', ':Refactor extract_var ', mode = { 'x' }, desc = 'Refactor extract_var' },
      { '<leader>Ri', ':Refactor inline_var', mode = { 'x', 'n' }, desc = 'Refactor inline_var' },
      { '<leader>RI', ':Refactor inline_func', mode = { 'n' }, desc = 'Refactor inline_func' },
      { '<leader>Rb', ':Refactor extract_block', mode = { 'n' }, desc = 'Refactor extract_block' },
      { '<leader>Rbf', ':Refactor extract_block_to_file', mode = { 'n' }, desc = 'Refactor extract_block_to_file' },
    },
    config = function()
      require('refactoring').setup()
    end,
  },
}
