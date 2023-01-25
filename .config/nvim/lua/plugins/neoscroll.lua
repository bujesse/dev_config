local M = {}

function M.config()
  require('neoscroll').setup({
    mappings = {},
  })

  local t = {}

  t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '55', [['sine']] } }
  t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '55', [['sine']] } }
  t['zz'] = { 'zz', { '55' } }

  require('neoscroll.config').set_mappings(t)
end

return M
