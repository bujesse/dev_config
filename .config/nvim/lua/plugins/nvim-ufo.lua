-- from the github docs:
local function virtual_text_handler(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = ('  %d '):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, 'MoreMsg' })
  return newVirtText
end

return {
  -- better folds
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
      {
        'luukvbaal/statuscol.nvim',
        config = function()
          local builtin = require('statuscol.builtin')
          -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
          require('statuscol').setup({
            -- foldfunc = 'builtin',
            -- order = 'SFNs',
            setopt = true,
            relculright = true,
            -- segments = {
            --   { text = { '%s' }, click = 'v:lua.ScSa' },
            --   { text = { builtin.lnumfunc }, click = 'v:lua.ScLa' },
            --   { text = { ' ', builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
            -- },
            segments = {
              {
                sign = {
                  name = {
                    'Diagnostic',
                  },
                  maxwidth = 1,
                  colwidth = 1,
                  auto = false,
                },
                click = 'v:lua.ScSa',
              },
              {
                sign = {
                  name = {
                    'Dap',
                    'neotest',
                  },
                  maxwidth = 1,
                  colwidth = 1,
                  auto = false,
                },
                click = 'v:lua.ScLa',
              },
              { text = { builtin.lnumfunc }, click = 'v:lua.ScLa' },
              {
                sign = {
                  name = { 'GitSigns' },
                  maxwidth = 1,
                  colwidth = 1,
                  auto = false,
                  fillchar = '│',
                  fillcharhl = 'StatusColumnSeparator',
                },
                click = 'v:lua.ScSa',
              },
            },
            ft_ignore = {
              'help',
              'vim',
              'alpha',
              'dashboard',
              'neo-tree',
              'Trouble',
              'noice',
              'lazy',
              'toggleterm',
            },
          })
        end,
      },
    },
    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.numberwidth = 4

      local ft_map = {
        Outline = '',
      }
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return ft_map[filetype] or { 'lsp', 'indent' }
          -- return { 'treesitter', 'indent' }
        end,
        fold_virt_text_handler = virtual_text_handler,
        open_fold_hl_timeout = 150,
        close_fold_kinds = { 'imports', 'comment' },
        preview = {
          mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>',
          },
        },
      })

      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
      vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- Usage: 1zm 2zm 3zm ...
      vim.keymap.set('n', 'zp', require('ufo').peekFoldedLinesUnderCursor)
      vim.keymap.set('n', '[z', require('ufo').goPreviousClosedFold)
      vim.keymap.set('n', ']z', require('ufo').goNextClosedFold)
      vim.keymap.set('n', 'zk', require('ufo').goPreviousStartFold) -- zj goes to next start fold, and is built in
      -- vim.keymap.set('n', 'zo', 'zO')
    end,
  },
}
