local M = {}

function M.config()
  local opts = {
    noremap = false,
    silent = true,
  }

  vim.api.nvim_set_keymap('n', 'gs', '<Plug>SearchNormal', opts)
  vim.api.nvim_set_keymap('n', 'gs', '<Plug>SearchVisual', opts)
end

return M
