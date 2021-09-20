-- TODO: put everything in the M convention and call config() or somerhing
require('core.config')
require('core.commands').config()

local autocmds = require('core.autocommands')
autocmds.define_augroups(autocmds.autocommands)

require('plugins')

require('core.keymappings').setup()
