local M = {}

M.config = function()
  local opts = {
    noremap = false,
    silent = false,
  }

  vim.api.nvim_set_keymap('n', 'R', '<Plug>ReplaceWithRegisterOperator', opts)
  vim.api.nvim_set_keymap('n', 'RR', '<Plug>ReplaceWithRegisterLine', opts)
  vim.api.nvim_set_keymap('x', 'R', '<Plug>ReplaceWithRegisterVisual', opts)
end

return M
