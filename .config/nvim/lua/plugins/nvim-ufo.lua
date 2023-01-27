local M = {}

function M.config()
  vim.o.foldcolumn = '0' -- '1' displays folds in the column but it's ugly for now - https://github.com/kevinhwang91/nvim-ufo/issues/4
  vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true

  -- Option 3: treesitter as a main provider instead
  -- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
  -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
  require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
      return { 'treesitter', 'indent' }
    end,
    fold_virt_text_handler = M.virtual_text_handler,
    open_fold_hl_timeout = 150,
    close_fold_kinds = { 'imports', 'comment' },
    preview = {
      mappings = {
        scrollU = '<C-u>',
        scrollD = '<C-d>'
      }
    }
  })

  -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
  vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
  vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
  vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
  vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)
  vim.keymap.set('n', 'zp', require('ufo').peekFoldedLinesUnderCursor) -- closeAllFolds == closeFoldsWith(0)
  vim.keymap.set('n', '[z', require('ufo').goPreviousClosedFold)
  vim.keymap.set('n', ']z', require('ufo').goNextClosedFold)
  vim.keymap.set('n', 'zo', 'zO')

  -- Option 2: nvim lsp as LSP client
  -- Tell the server the capability of foldingRange,
  -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
  -- local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- capabilities.textDocument.foldingRange = {
  --   dynamicRegistration = false,
  --   lineFoldingOnly = true
  -- }
  -- local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
  -- for _, ls in ipairs(language_servers) do
  --   require('lspconfig')[ls].setup({
  --     capabilities = capabilities
  --     -- you can add other fields for setting up lsp server in this table
  --   })
  -- end
  -- require('ufo').setup()
end

-- from the github docs:
M.virtual_text_handler = function(virtText, lnum, endLnum, width, truncate)
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

return M
