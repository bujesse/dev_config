-- TODO: put everything in the M convention and call config() or somerhing
require('core.config')

require('plugins.lsp.nvim-lspconfig')
require('plugins.lsp.lspsaga')
require('plugins.lsp.null-ls.init').config()

local autocmds = require('core.autocommands')
autocmds.define_augroups(autocmds.autocommands)

require('plugins.nvim-cmp')
require('plugins.nvim-treesitter')
require('plugins.nvim-web-devicons')
require('plugins.lualine.init')
-- require('plugins.bufferline')
require('plugins.barbar').config()
require('plugins.neoscroll')
require('plugins.telescope')
require('plugins.luasnip')
require('plugins.nvim-autopairs')
require('plugins.indent-blankline')
require('plugins.lightspeed')
require('plugins.revj')
require('plugins.which-key')
require('plugins.abolish')
require('plugins.gitsigns')

require('plugins.dap.nvim-dap')
require('plugins.dap.nvim-dap-ui')
