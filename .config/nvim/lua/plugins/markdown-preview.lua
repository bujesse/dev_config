local M = {}

M.config = function()
  vim.g.mkdp_auto_start = 1
  vim.g.mkdp_auto_close = 1

  -- local opts = {
  --   noremap = false,
  --   silent = false,
  -- }
  -- vim.api.nvim_set_keymap('n', 'gl', '<Plug>(MarkdownPreviewToggle)', opts)
end

return M
