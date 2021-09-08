M = {}

function M.config()
  require('hop').setup({
    reverse_distribution = true,
    keys = "asdghklweriozxcvnmfj/;'",
  })
  vim.api.nvim_set_keymap('n', 'S', "<cmd>lua require'hop'.hint_char1({direction = 1})<CR>", {})
  vim.api.nvim_set_keymap('n', 's', "<cmd>lua require'hop'.hint_char1({direction = 2})<CR>", {})
end

return M
