-- TODO: put everything in the M convention and call config() or somerhing
require('core.config')
require('core.commands').config()

require('plugins.lsp.nvim-lspconfig')
require('plugins.lsp.null-ls.init').config()

local autocmds = require('core.autocommands')
autocmds.define_augroups(autocmds.autocommands)

require('plugins.nvim-cmp')
require('plugins.nvim-treesitter').config()
require('plugins.nvim-web-devicons')
require('plugins.lualine.init')
require('plugins.startify').config()
require('plugins.neoscroll')
require('plugins.telescope')
require('plugins.luasnip')
require('plugins.nvim-autopairs')
require('plugins.indent-blankline')
require('plugins.hop').config()
require('plugins.clever-f').config()
require('plugins.splitjoin').config()
require('plugins.which-key')
require('plugins.abolish')
require('plugins.nvim-tree').setup()
require('plugins.barbar').config()
-- require('plugins.bufferline').config()
require('plugins.gitsigns')

require('plugins.dap.nvim-dap')
require('plugins.dap.nvim-dap-ui')

require('core.keymappings').setup()
