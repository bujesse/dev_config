local M = {}

function M.config()
  vim.g.yoinkAutoFormatPaste = 1
  vim.g.yoinkSyncNumberedRegisters = 1

  local opts = {
    noremap = false,
    silent = false,
  }

  vim.api.nvim_set_keymap('n', 'p', '<Plug>(YoinkPaste_p)', opts)
  vim.api.nvim_set_keymap('n', 'P', '<Plug>(YoinkPaste_P)', opts)
  vim.api.nvim_set_keymap('n', '[y', '<Plug>(YoinkRotateBack)', opts)
  vim.api.nvim_set_keymap('n', ']y', '<Plug>(YoinkRotateForward)', opts)
end

return M
