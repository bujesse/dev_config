local M = {}

function M.config()
  local opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap('n', '<Leader>ma', ':lua require("harpoon.mark").add_file()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>mm', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', opts)

  vim.api.nvim_set_keymap('n', '<Leader>m1', ':lua require("harpoon.ui").nav_file(1)<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>m2', ':lua require("harpoon.ui").nav_file(2)<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>m3', ':lua require("harpoon.ui").nav_file(3)<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>m4', ':lua require("harpoon.ui").nav_file(4)<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>m5', ':lua require("harpoon.ui").nav_file(5)<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>m6', ':lua require("harpoon.ui").nav_file(6)<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>m7', ':lua require("harpoon.ui").nav_file(7)<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>m8', ':lua require("harpoon.ui").nav_file(8)<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>m9', ':lua require("harpoon.ui").nav_file(9)<CR>', opts)
end

return M
