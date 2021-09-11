local M = {}

M.config = function()
  local opts = {
    noremap = true,
    silent = true,
  }

  vim.api.nvim_set_keymap('n', '<Leader>B', ':Git blame<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>L', ':Gclog %<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>D', ':Gdiffsplit<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>M', ':Git mergetool<CR>', opts)
end

return M
