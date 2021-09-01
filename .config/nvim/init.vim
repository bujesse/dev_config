""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"        _   _       _                  _____             __ _               "
"       | \ | |     (_)                / ____|           / _(_)              "
"       |  \| |_   ___ _ __ ___       | |     ___  _ __ | |_ _  __ _         "
"       | . ` \ \ / / | '_ ` _ \      | |    / _ \| '_ \|  _| |/ _` |        "
"       | |\  |\ V /| | | | | | |     | |___| (_) | | | | | | | (_| |        "
"       |_| \_| \_/ |_|_| |_| |_|      \_____\___/|_| |_|_| |_|\__, |        "
"                                                               __/ |        "
"                                                              |___/         "
"                                                                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let mapleader=","

" Source before/plugin
" Useful for setting mappings before the plugins are sourced
source ~/.config/nvim/before/plugins/ReplaceWithRegister.vim

" General Settings
source ~/.config/nvim/core/plugins.vim
source ~/.config/nvim/core/options.vim
source ~/.config/nvim/core/globals.vim
source ~/.config/nvim/core/autocommands.vim
source ~/.config/nvim/core/ui.vim

" Lua Plugin Configuration (.vim plugins are in after/plugin)
luafile ~/.config/nvim/lua/plugins/nvim-lspconfig.lua
luafile ~/.config/nvim/lua/plugins/nvim-cmp.lua
luafile ~/.config/nvim/lua/plugins/nvim-treesitter.lua
luafile ~/.config/nvim/lua/plugins/nvim-web-devicons.lua
luafile ~/.config/nvim/lua/plugins/lualine.lua
luafile ~/.config/nvim/lua/plugins/bufferline.lua
luafile ~/.config/nvim/lua/plugins/lspsaga.lua
luafile ~/.config/nvim/lua/plugins/neoscroll.lua
luafile ~/.config/nvim/lua/plugins/gitsigns.lua
luafile ~/.config/nvim/lua/plugins/telescope.lua
luafile ~/.config/nvim/lua/plugins/luasnip.lua
luafile ~/.config/nvim/lua/plugins/nvim-autopairs.lua
luafile ~/.config/nvim/lua/plugins/indent-blankline.lua

source ~/.config/nvim/core/mappings.vim

