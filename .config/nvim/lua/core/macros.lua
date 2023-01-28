local M = {}

function M.config()
  local opts = { noremap = true, silent = true }

  vim.keymap.set({ 'n' }, '<Leader>..', [[:wa<cr>:source %<cr>]],
    vim.tbl_deep_extend('force', opts, { desc = 'Source lua' }))
end

return M
