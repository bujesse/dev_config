local M = {}

function M.config()
  local opts = { noremap = true, silent = true }

  vim.keymap.set({ 'n' }, '<Leader>.m', [[:lua R("core.macros").config()<CR>]], { desc = 'Source Macros' })
  vim.keymap.set(
    { 'n' },
    '<Leader>em',
    [[:lua vim.cmd('edit ' .. CONFIG_PATH .. '/lua/core/macros.lua')<CR>]],
    { desc = 'Edit Macros' }
  )

  vim.keymap.set(
    { 'n' },
    '<Leader>..',
    [[:wa<cr>:source %<cr>]],
    vim.tbl_deep_extend('force', opts, { desc = 'Source lua' })
  )

  vim.keymap.set(
    'n',
    '<Leader>dt',
    [[:put =strftime('(%Y-%m-%d %H:%M)')<CR>kJ]],
    vim.tbl_deep_extend('force', opts, { desc = 'Insert timestamp' })
  )

  -- vim.keymap.set({ 'n' }, "<Leader>p", [[mj<esc>Iprint(<esc>A)<esc>`j6l]], { desc = 'surround with print' })
end

return M
