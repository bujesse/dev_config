return {
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      vim.g.skip_ts_context_commentstring_module = true
      require('ts_context_commentstring').setup({})
    end,
  },

  -- Treesitter actions. Toggle booleans, quotes, conditionals,
  {
    'ckolkey/ts-node-action',
    dependencies = { 'nvim-treesitter' },
    config = true,
    keys = {
      {
        'ga',
        function()
          require('ts-node-action').node_action()
        end,
        desc = 'Trigger Node Action',
      },
    },
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    config = function()
      require('nvim-treesitter.configs').setup({
        textobjects = {
          swap = {
            enable = true,
            swap_next = {
              [']a'] = '@parameter.inner',
              [']b'] = '@block.inner',
            },
            swap_previous = {
              ['[a'] = '@parameter.inner',
              ['[b'] = '@block.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']f'] = '@function.outer',
              [']]'] = { query = '@class.outer', desc = 'Next class start' },
              --
              -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
              [']o'] = '@loop.*',
              -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
              --
              -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
              -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
              -- [']s'] = { query = '@local.scope', query_group = 'locals', desc = 'Next scope' },
              -- [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
            },
            goto_next_end = {
              [']F'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[f'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[F'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
            -- Below will go to either the start or the end, whichever is closer.
            -- Use if you want more granular movements
            -- Make it even more gradual by adding multiple queries and regex.
            goto_next = {
              -- [']d'] = '@conditional.outer',
            },
            goto_previous = {
              -- ['[d'] = '@conditional.outer',
            },
          },
        },
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    cond = true,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        -- shows the code context of the currently visible buffer contents
        'nvim-treesitter/nvim-treesitter-context',
        opts = { enable = true },
        keys = {
          { 'yoc', '<CMD>TSContext toggle<CR>', desc = 'Toggle Treesitter Context' },
          {
            '[c',
            function()
              require('treesitter-context').go_to_context()
            end,
            desc = 'Go to Context',
          },
        },
      },
      {
        'windwp/nvim-ts-autotag',
        config = function()
          require('nvim-ts-autotag').setup()
        end,
      },
    },
    version = false,
    event = 'BufReadPost',
    build = ':TSUpdate',
    keys = {
      { '<Cr>', desc = 'Increment selection' },
      { '<bs>', desc = 'Schrink selection', mode = 'x' },
    },
    ---@type TSConfig
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
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
        'css',

        'toml',
        'rust',
        'regex',

        'javascript',
        'typescript',
        'vue',

        'go',
        'gomod',
        'gosum',
        'gotmpl',
        'templ',

        'markdown',
        'markdown_inline',
      },
      incremental_selection = {
        enable = false,
        keymaps = {
          init_selection = '<C-A-o>',
          node_incremental = '<C-A-o>',
          -- scope_incremental = '<nop>',
          node_decremental = '<C-A-i>',
        },
        is_supported = function()
          -- disable for command history window
          local mode = vim.api.nvim_get_mode().mode
          if mode == 'c' then
            return false
          end
          return true
        end,
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']f'] = { query = '@function.outer', desc = 'Next Method start' },
            [']]'] = { query = '@class.outer', desc = 'Next Class start' },
            --
            -- You can use regex matching and/or pass a list in a "query" key to group multiple queires.
            [']o'] = '@loop.*',
            -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
          },
          goto_next_end = {
            [']F'] = { query = '@function.outer', desc = 'Next Method end' },
            [']['] = { query = '@class.outer', desc = 'Next Class end' },
          },
          goto_previous_start = {
            ['[f'] = { query = '@function.outer', desc = 'Prev Method start' },
            ['[['] = { query = '@class.outer', desc = 'Prev Class start' },
          },
          goto_previous_end = {
            ['[F'] = { query = '@function.outer', desc = 'Prev Method end' },
            ['[]'] = { query = '@class.outer', desc = 'Prev Class end' },
          },
          -- Below will go to either the start or the end, whichever is closer.
          -- Use if you want more granular movements
          -- Make it even more gradual by adding multiple queries and regex.
          goto_next = {
            [']o'] = { query = { '@block.outer', '@conditional.outer', '@loop.outer' }, desc = 'Next block' },
          },
          goto_previous = {
            ['[o'] = { query = { '@block.outer', '@conditional.outer', '@loop.outer' }, desc = 'Prev block' },
          },
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      -- require('nvim-treesitter.install').compilers = { 'clang' }
    end,
  },

  {
    'ziontee113/SelectEase',
    enabled = false, -- This isn't ready yet as of (2023-02-18 14:54)
    config = function()
      local select_ease = require('SelectEase')

      local lua_query = [[
            ;; query
            ((identifier) @cap)
            ("string_content" @cap)
            ((true) @cap)
            ((false) @cap)
        ]]
      local python_query = [[
            ;; query
            ((identifier) @cap)
            ((string) @cap)
        ]]

      local queries = {
        lua = lua_query,
        python = python_query,
      }

      vim.keymap.set({ 'n', 'x', 's', 'i' }, '<C-A-k>', function()
        select_ease.select_node({
          queries = queries,
          direction = 'previous',
          vertical_drill_jump = true,
          visual_mode = true, -- if you want Visual Mode instead of Select Mode
        })
      end, {})
      vim.keymap.set({ 'n', 'x', 's', 'i' }, '<C-A-j>', function()
        select_ease.select_node({
          queries = queries,
          direction = 'next',
          vertical_drill_jump = true,
          visual_mode = true, -- if you want Visual Mode instead of Select Mode
        })
      end, {})
      vim.keymap.set({ 'n', 'x', 's', 'i' }, '<C-A-h>', function()
        select_ease.select_node({
          queries = queries,
          direction = 'previous',
          visual_mode = true, -- if you want Visual Mode instead of Select Mode
        })
      end, {})
      vim.keymap.set({ 'n', 'x', 's', 'i' }, '<C-A-l>', function()
        select_ease.select_node({
          queries = queries,
          direction = 'next',
          visual_mode = true, -- if you want Visual Mode instead of Select Mode
        })
      end, {})
    end,
  },

  {
    'sustech-data/wildfire.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('wildfire').setup()
    end,
  },
}
