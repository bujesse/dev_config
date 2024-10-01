return {

  -- completion
  {
    -- 'hrsh7th/nvim-cmp',
    'yioneko/nvim-cmp',
    branch = 'perf',
    dependencies = {
      'LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'luckasRanarison/tailwind-tools.nvim',
      'onsails/lspkind-nvim',
      { 'windwp/nvim-autopairs' },
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')

      local border_opts = {
        border = 'single',
        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
      }

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
      end

      -- Remove luasnip default
      vim.keymap.del('i', '<Tab>')
      vim.keymap.del('i', '<S-Tab>')

      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-u>'] = cmp.mapping.scroll_docs(4),
          ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-c>'] = cmp.mapping.close(),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<A-s>'] = cmp.mapping.complete({
            config = {
              sources = {
                { name = 'luasnip' },
              },
            },
          }),
          ['<C-e>'] = cmp.mapping.close(),

          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<C-n>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<C-p>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              local utils = require('core.utils')
              local last_char = utils.get_cursor_prev_char()
              -- Don't do completion for opening tags
              local BLACKLIST = { '{', '[', '(', '>' }
              if not utils.table_contains(BLACKLIST, last_char) then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
              else
                fallback()
              end
            else
              fallback()
            end
          end, { 'i', 's' }),
        },

        window = {
          completion = cmp.config.window.bordered(border_opts),
          documentation = cmp.config.window.bordered(border_opts),
        },

        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 1000 },
          -- { name = 'luasnip', priority = 750 },
          { name = 'buffer', priority = 500 },
          -- { name = 'nvim_lua', priority = 5 },
          { name = 'path', priority = 250 },
          -- { name = 'treesitter', priority = 4 },
        }),

        sorting = {
          priority_weight = 1.0,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,

            -- copied from cmp-under, but I don't think I need the plugin for this.
            -- I might add some more of my own.
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find('^_+')
              local _, entry2_under = entry2.completion_item.label:find('^_+')
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,

            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },

        duplicates = {
          nvim_lsp = 1,
          luasnip = 1,
          cmp_tabnine = 1,
          buffer = 1,
          path = 1,
        },

        matching = {
          -- disallow_fuzzy_matching = true,
          -- disallow_fullfuzzy_matching = true,
          -- disallow_partial_fuzzy_matching = true,
          -- disallow_partial_matching = false,
          -- disallow_prefix_unmatching = true,
        },

        formatting = {
          format = require('lspkind').cmp_format({
            mode = 'symbol_text',
            before = function(entry, vim_item)
              vim_item = require('tailwind-tools.cmp').lspkind_format(entry, vim_item)
              vim_item.kind = lspkind.presets.default[vim_item.kind] .. ' ' .. vim_item.kind
              vim_item.abbr = string.sub(vim_item.abbr, 1, 30)
              vim_item.menu = ({
                nvim_lsp = '[LSP]',
                buffer = '[Buffer]',
                path = '[Path]',
                luasnip = '[LuaSnip]',
                treesitter = '[TS]',
                nvim_lua = '[NvimLua]',
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline({ '/', '?' }, {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = {
      --     { name = 'buffer' },
      --   },
      -- })

      -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline(':', {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = cmp.config.sources({
      --     { name = 'path' },
      --   }, {
      --     { name = 'cmdline' },
      --   }),
      -- })

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
    end,
  },
}
