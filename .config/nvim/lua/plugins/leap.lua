local M = {}

function M.config()
  local leap = require('leap')
  leap.opts.safe_labels = {}
  vim.keymap.set({ 'n', 'x' }, 's', ":lua require('leap').leap({ target_windows = { vim.fn.win_getid() } })<CR>", {})
  -- vim.keymap.set({ 'n' }, 'S', ":lua require('leap').leap({ target_windows = { require('leap.util').get_enterable_windows() } })<CR>", {})
end

return M
