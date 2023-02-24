return {

  -- completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      { 'windwp/nvim-autopairs', config = true },
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')

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

        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 8 },
          { name = 'luasnip', priority = 7 },
          { name = 'buffer', priority = 7 },
          { name = 'nvim_lua', priority = 5 },
          { name = 'path', priority = 4 },
          -- { name = 'treesitter', priority = 4 },
        }),

        sorting = {
          priority_weight = 1.0,
          comparators = {
            -- compare.score_offset, -- not good at all
            -- function(...)
            --   return require('cmp_buffer'):compare_locality(...)
            -- end,
            cmp.config.compare.locality,
            cmp.config.compare.recently_used,
            cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
            cmp.config.compare.offset,
            cmp.config.compare.order,
            -- compare.scopes, -- what?
            -- compare.sort_text,
            -- compare.exact,
            -- compare.kind,
            -- compare.length, -- useless
          },
        },

        formatting = {
          format = function(entry, vim_item)
            -- fancy icons from lspkind
            vim_item.kind = lspkind.presets.default[vim_item.kind] .. ' ' .. vim_item.kind

            -- vim_item.abbr = string.sub(vim_item.abbr, 1, 30)

            -- set a name for each source
            vim_item.menu = ({
              nvim_lsp = '[LSP]',
              buffer = '[Buffer]',
              path = '[Path]',
              luasnip = '[LuaSnip]',
              treesitter = '[TS]',
              nvim_lua = '[NvimLua]',
            })[entry.source.name]
            vim_item.dup = ({
              buffer = 1,
              path = 1,
              nvim_lsp = 0,
            })[entry.source.name] or 0
            return vim_item
          end,
        },
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })

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
