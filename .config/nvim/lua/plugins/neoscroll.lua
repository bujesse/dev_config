require('neoscroll').setup()

local t = {}

t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '65', [['sine']]}}
t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '65', [['sine']]}}
t['zz'] = {'zz', { '65' }}

require('neoscroll.config').set_mappings(t)

