local M = {}

M.config = function()
  local opts = {
    noremap = false,
    silent = true,
  }

  vim.api.nvim_set_keymap('n', 'gs', '<Plug>SearchNormal', opts)
  vim.api.nvim_set_keymap('n', 'gs', '<Plug>SearchVisual', opts)
end

return M
