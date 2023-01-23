local M = {}

function M.config()
  vim.api.nvim_set_keymap('n', ';', '<Plug>(clever-f-repeat-forward)', { noremap = false, silent = false })
  vim.api.nvim_set_keymap('n', '<Leader>,', '<Plug>(clever-f-repeat-back)', { noremap = false, silent = false })
  vim.api.nvim_set_keymap('x', ';', '<Plug>(clever-f-repeat-forward)', { noremap = false, silent = false })
  vim.api.nvim_set_keymap('x', '<Leader>,', '<Plug>(clever-f-repeat-back)', { noremap = false, silent = false })
  vim.g.clever_f_across_no_line = 0
  -- vim.g.clever_f_fix_key_direction = 1
  vim.g.clever_f_smart_case = 1
  vim.g.clever_f_mark_direct = 0

  -- Instant timeout allows for quickly chaining different targets
  vim.g.clever_f_timeout_ms = 1
end

return M
