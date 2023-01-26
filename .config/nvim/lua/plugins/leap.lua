local M = {}

function M.config()
  local leap = require('leap')
  leap.opts.safe_labels = {}
  leap.opts.labels = {
    'j', 'f', 'k', 'd', 'l', 's', ';', 'a', 'e', 'w', 'o', 'u', 'r', 'n', 'v', 'm', 'c', 'x', 'z', '/', 'p', 'q', 'g',
    'h', 'J', 'F', 'K', 'D', 'L', 'S', 'A'
  }
  vim.keymap.set({ 'n', 'x' }, 's', ":lua require('leap').leap({ target_windows = { vim.fn.win_getid() } })<CR>", {})
  -- vim.keymap.set({ 'n' }, 'S', ":lua require('leap').leap({ target_windows = { require('leap.util').get_enterable_windows() } })<CR>", {})
end

return M
