local M = {}

function M.config()
  local opts = { noremap = true, silent = true }

  local function harpoon_add()
    require("harpoon.mark").add_file()
    local filename = vim.api.nvim_buf_get_name(0)
    print('Harpoon Add: ' .. filename)
  end

  vim.keymap.set('n', '<Leader>ma', harpoon_add, opts)
  vim.keymap.set('n', '<Leader>mm', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', opts)
  vim.keymap.set('n', '<Leader>m1', ':lua require("harpoon.ui").nav_file(1)<CR>', opts)
  vim.keymap.set('n', '<Leader>m2', ':lua require("harpoon.ui").nav_file(2)<CR>', opts)
  vim.keymap.set('n', '<Leader>m3', ':lua require("harpoon.ui").nav_file(3)<CR>', opts)
  vim.keymap.set('n', '<Leader>m4', ':lua require("harpoon.ui").nav_file(4)<CR>', opts)
  vim.keymap.set('n', '<Leader>m5', ':lua require("harpoon.ui").nav_file(5)<CR>', opts)
  vim.keymap.set('n', '<Leader>m6', ':lua require("harpoon.ui").nav_file(6)<CR>', opts)
  vim.keymap.set('n', '<Leader>m7', ':lua require("harpoon.ui").nav_file(7)<CR>', opts)
  vim.keymap.set('n', '<Leader>m8', ':lua require("harpoon.ui").nav_file(8)<CR>', opts)
  vim.keymap.set('n', '<Leader>m9', ':lua require("harpoon.ui").nav_file(9)<CR>', opts)
end

return M
