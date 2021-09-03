require('dap')
vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})

local opts = {
  noremap=true,
  silent=true,
}

vim.api.nvim_set_keymap('n', '<Space>b', ":lua require'dap'.toggle_breakpoint()<CR>", opts)
vim.api.nvim_set_keymap('n', '<Space>B', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
vim.api.nvim_set_keymap('n', '<Space>c', ':lua require"dap".continue()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Space>j', ':lua require"dap".run_to_cursor()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Space>n', ':lua require"dap".step_over()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Space>i', ':lua require"dap".step_into()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Space>o', ':lua require"dap".step_out()<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<Space>', ':lua require"dap".repl.open()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Space>dl', ':lua require"dap".run_last()<CR>', opts)
