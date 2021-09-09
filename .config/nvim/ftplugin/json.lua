local format_fn = "lua vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line('$'), 0 })"
-- vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>af', '<cmd>' .. format_fn .. '<CR>', { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>af', '<cmd>lua print("foo")<CR>', { noremap = true, silent = true })

-- Swap out autoformat command
-- NOTE: toggle not implemented; always autoformat JSON
require('core.autocommands').define_augroups({
  autoformat = {
    {
      'BufWritePre',
      '<buffer>',
      ':' .. format_fn,
    },
    -- This is a hack, but the format fn leaves the file dirty, so write again afterwards to remove that flag
    {
      'BufWritePost',
      '<buffer>',
      [[call timer_start(100, {-> execute("noautocmd write", "")})]],
    },
  },
})
