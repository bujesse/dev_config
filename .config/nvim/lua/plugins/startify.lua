local M = {}

function M.config()
  vim.g.ascii = {
    '⠀⠀⠀⠀⣠⣶⡾⠏⠉⠙⠳⢦⡀⠀⠀⠀⢠⠞⠉⠙⠲⡀⠀',
    '⠀⠀⠀⣴⠿⠏⠀⠀⠀⠀⠀⠀⢳⡀⠀⡏⠀⠀⠀⠀⠀⢷',
    '⠀⠀⢠⣟⣋⡀⢀⣀⣀⡀⠀⣀⡀⣧⠀⢸⠀⠀⠀⠀⠀ ⡇',
    '⠀⠀⢸⣯⡭⠁⠸⣛⣟⠆⡴⣻⡲⣿⠀⣸⠀ nv  ⡇',
    '⠀⠀⣟⣿⡭⠀⠀⠀⠀⠀⢱⠀⠀⣿⠀⢹⠀⠀⠀⠀⠀ ⡇',
    '⠀⠀⠙⢿⣯⠄⠀⠀⠀⢀⡀⠀⠀⡿⠀⠀⡇⠀⠀⠀⠀⡼',
    '⠀⠀⠀⠀⠹⣶⠆⠀⠀⠀⠀⠀⡴⠃⠀⠀⠘⠤⣄⣠⠞⠀',
    '⠀⠀⠀⠀⠀⢸⣷⡦⢤⡤⢤⣞⣁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
    '⠀⠀⢀⣤⣴⣿⣏⠁⠀⠀⠸⣏⢯⣷⣖⣦⡀⠀⠀⠀⠀⠀⠀',
    '⢀⣾⣽⣿⣿⣿⣿⠛⢲⣶⣾⢉⡷⣿⣿⠵⣿⠀⠀⠀⠀⠀⠀',
    '⣼⣿⠍⠉⣿⡭⠉⠙⢺⣇⣼⡏⠀⠀⠀⣄⢸⠀⠀⠀⠀⠀⠀',
    '⣿⣿⣧⣀⣿………⣀⣰⣏⣘⣆⣀⠀⠀',
  }

  vim.g.startify_bookmarks = {
    { n = '~/.config/nvim/init.vim' },
    { i = '~/.ideavimrc' },
    { z = '~/.zshrc' },
    { h = '~/dev_config/mac_to_windows.ahk' },
    { a = '/mnt/c/Users/Jesse/AppData/Roaming/alacritty/alacritty.yml' },
  }

  vim.g.startify_commands = {
    -- ':help reference',
    -- { 'Vim Reference', 'h ref' },
    -- { h = 'h ref' },
    { m = { '  MRU', 'Telescope frecency' } },
    { f = { '  Find Files', 'Telescope find_files' } },
    { w = { '  Find Word', 'Telescope live_grep' } },
    { up = { '  Update Plugins', 'PlugUpdate' } },
    { ug = { '  Upgrade Plugin Manager', 'PlugUpgrade' } },
    { ts = { '  Update Treesitter', 'TSUpdate' } },
    { ch = { '  Check Health', 'checkhealth' } },
  }

  vim.g.startify_lists = {
    { type = 'sessions', header = { '  Sessions' } },
    { type = 'bookmarks', header = { '  Bookmarks' } },
    { type = 'commands', header = { '  Commands' } },
  }

  vim.g.startify_session_autoload = 1
  vim.g.startify_change_to_vcs_root = 1
  vim.g.startify_session_sort = 1
  vim.g.startify_session_persistence = 1
  vim.g.startify_session_dir = CACHE_PATH .. '/sessions'

  -- Help texts should not be added to the session
  vim.g.startify_session_before_save = { 'silent! helpclose' }

  -- This prevents NvimTree from freaking out when loading a session
  -- Also, barbar doesn't load immediately because it
  -- ignores the autocommands while SessionLoad is set
  vim.g.startify_session_remove_lines = { 'unlet SessionLoad' }
  vim.g.startify_session_savecmds = {
    'silent! bw! NvimTree',
    'unlet SessionLoad',
  }

  vim.g.startify_custom_header = 'startify#pad(g:ascii + startify#fortune#boxed())'

  -- Save and load sessions
  vim.api.nvim_set_keymap('n', '<F5>', ':SSave!<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<F8>', ':SLoad<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>s', ':Startify<CR>', { noremap = true, silent = true })
end

return M