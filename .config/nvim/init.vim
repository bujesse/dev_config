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

" TODO:
" * better diagnostic for gruvbox
" * Find better Search highlighting for gruvbox
" * Better yank highlighting for gruvbox

" LEARN:
" * Use <C-f> in command mode to edit commands with normal mode and run prev
" * Use dw to delete until non-whitespace (getting rid of excess indent)
" * :on (or <c-w>o) to close all windows except the current one
" * Use the "Last inserted text" register (".) with <C-r>
" * reopen accidentally closed buffer with <C-o>
" * Lightspeed is actually always a 2-char motion. cycle groups with <tab>

let mapleader=","

" Source before/plugin
" Useful for setting mappings before the plugins are sourced
source ~/.config/nvim/before/plugins/ReplaceWithRegister.vim

" General Settings
source ~/.config/nvim/core/plugins.vim
source ~/.config/nvim/core/options.vim
source ~/.config/nvim/core/globals.vim
source ~/.config/nvim/core/autocommands.vim

" Theme
source ~/.config/nvim/core/themes/gruvbox-material.vim
" lualine: ~/.config/nvim/lua/plugins/lualine/init.lua
" enable plugin: ~/.config/nvim/core/plugins.vim

" Lua Plugin Configuration (.vim plugins are in after/plugin)
luafile ~/.config/nvim/lua/core/setup.lua

source ~/.config/nvim/core/mappings.vim

