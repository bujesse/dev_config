local M = {}

function M.config()
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
