local M = {}

function M.config()
  local cmp = require('cmp')
  local luasnip = require("luasnip")
  local lspkind = require('lspkind')

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end


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
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          vim.api.nvim_feedkeys(t('<C-d>'), 'n', true)
        end
      end, { 'i', 's' }),

      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
    },

    -- You should specify your *installed* sources.
    sources = {
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'luasnip' },
      { name = 'nvim_lua' },
      { name = 'treesitter' },
      { name = 'buffer' },
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

  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
end

return M
