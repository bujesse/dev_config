local M = {}

function M.config()
  require('treesj').setup({
    use_default_keymaps = false,
    max_join_length = 150,
  })

  vim.keymap.set('n', 'gs', ':TSJToggle<cr>', { noremap = true, silent = true })
end

return M
