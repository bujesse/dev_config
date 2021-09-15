local M = {}

M.config = function()
  local opts = {
    noremap = false,
    silent = false,
  }

  vim.api.nvim_set_keymap('n', 'gl', '<Plug>(LiveEasyAlign)', opts)
  vim.api.nvim_set_keymap('x', 'gl', '<Plug>(LiveEasyAlign)', opts)

  -- nmap gL <Plug>(LiveEasyAlign)
  -- xmap gL <Plug>(LiveEasyAlign)
end

return M
