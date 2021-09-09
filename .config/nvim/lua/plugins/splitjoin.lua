local M = {}

function M.config()
  vim.g.splitjoin_split_mapping = ''
  vim.g.splitjoin_join_mapping = ''
  vim.g.splitjoin_trailing_comma = 1
  vim.g.splitjoin_python_brackets_on_separate_lines = 1

  vim.api.nvim_set_keymap('n', 'gJ', ':SplitjoinJoin<cr>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'gS', ':SplitjoinSplit<cr>', { noremap = true, silent = true })
end

return M
