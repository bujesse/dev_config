vim.cmd [[let &packpath = &runtimepath]]

require('core.config')
require('core.commands').config()

local autocmds = require('core.autocommands')
autocmds.define_augroups(autocmds.autocommands)

local plugins = require('packer-plugins')
local plugin_loader = require('plugin-loader').init()
plugin_loader:load({plugins})

-- require('core.keymappings').setup()

-- require('plugins.lsp.nvim-lspconfig').config()
-- require('plugins.lsp.null-ls.init').config()

-- require('plugins.nvim-cmp').config()
-- require('plugins.nvim-treesitter').config()
-- require('plugins.nvim-web-devicons').config()
-- require('plugins.lualine.init').config()
-- require('plugins.startify').config()
-- require('plugins.neoscroll').config()
-- require('plugins.telescope').config()
-- require('plugins.luasnip').config()
-- require('plugins.nvim-autopairs').config()
-- require('plugins.indent-blankline').config()
-- require('plugins.hop').config()
-- require('plugins.clever-f').config()
-- require('plugins.splitjoin').config()
-- require('plugins.which-key').config()
-- require('plugins.abolish').config()
-- require('plugins.nvim-tree').setup()
-- require('plugins.barbar').config()
-- require('plugins.gitsigns').config()

-- require('plugins.dap.nvim-dap').config()
-- require('plugins.dap.nvim-dap-ui').config()
