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

" Source before/plugin
" Useful for setting mappings before the plugins are sourced
source ~/.config/nvim/before/plugins/ReplaceWithRegister.vim

" General Settings
source ~/.config/nvim/core/plugins.vim
source ~/.config/nvim/core/options.vim
source ~/.config/nvim/core/globals.vim
source ~/.config/nvim/core/mappings.vim
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

" LSP files
" Manually installed lsp's will have to go here
" luafile ~/.config/nvim/lua/lsp/python-ls.lua

