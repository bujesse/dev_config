local M = {}

function M.config()
  require('symbols-outline').setup({
    keymaps = {
      close = { '<Esc>', 'q' },
      goto_location = '<Cr>',
      focus_location = 'o',
      hover_symbol = 'gh',
      toggle_preview = 'P',
      rename_symbol = 'r',
      code_actions = 'a',
      fold = 'h',
      unfold = 'l',
      fold_all = 'W',
      unfold_all = 'E',
      fold_reset = 'R',
    },
  })

  vim.keymap.set('n', '<Leader>2', '<Cmd>SymbolsOutline<CR>', { desc = 'Symbols Outline' })
end

return M
