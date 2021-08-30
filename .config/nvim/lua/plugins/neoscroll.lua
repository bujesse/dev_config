require('neoscroll').setup()

local t = {}

t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '50', [['sine']]}}
t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '50', [['sine']]}}
t['zz'] = {'zz', { '50' }}

require('neoscroll.config').set_mappings(t)

