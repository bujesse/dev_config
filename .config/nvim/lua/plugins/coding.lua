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

  -- TODO: implmemnt lazyvim
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
      -- move_cursor = false,
    },
  },

  -- comments
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        -- Required for nvim-ts-context-commentstring
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
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
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
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
}
