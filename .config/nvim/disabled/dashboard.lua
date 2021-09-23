local M = {}

M.config = function()
  vim.g.dashboard_disable_at_vimenter = 0
  vim.g.dashboard_custom_header = {
    '⠀⠀⠀⠀⣠⣶⡾⠏⠉⠙⠳⢦⡀⠀⠀⠀⢠⠞⠉⠙⠲⡀⠀',
    '⠀⠀⠀⣴⠿⠏⠀⠀⠀⠀⠀⠀⢳⡀⠀⡏⠀⠀⠀⠀⠀⢷',
    '⠀⠀⢠⣟⣋⡀⢀⣀⣀⡀⠀⣀⡀⣧⠀⢸⠀⠀⠀⠀⠀ ⡇',
    '⠀⠀⢸⣯⡭⠁⠸⣛⣟⠆⡴⣻⡲⣿⠀⣸⠀Nvim ⡇',
    '⠀⠀⣟⣿⡭⠀⠀⠀⠀⠀⢱⠀⠀⣿⠀⢹⠀⠀⠀⠀⠀ ⡇',
    '⠀⠀⠙⢿⣯⠄⠀⠀⠀⢀⡀⠀⠀⡿⠀⠀⡇⠀⠀⠀⠀⡼',
    '⠀⠀⠀⠀⠹⣶⠆⠀⠀⠀⠀⠀⡴⠃⠀⠀⠘⠤⣄⣠⠞⠀',
    '⠀⠀⠀⠀⠀⢸⣷⡦⢤⡤⢤⣞⣁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
    '⠀⠀⢀⣤⣴⣿⣏⠁⠀⠀⠸⣏⢯⣷⣖⣦⡀⠀⠀⠀⠀⠀⠀',
    '⢀⣾⣽⣿⣿⣿⣿⠛⢲⣶⣾⢉⡷⣿⣿⠵⣿⠀⠀⠀⠀⠀⠀',
    '⣼⣿⠍⠉⣿⡭⠉⠙⢺⣇⣼⡏⠀⠀⠀⣄⢸⠀⠀⠀⠀⠀⠀',
    '⣿⣿⣧⣀⣿………⣀⣰⣏⣘⣆⣀⠀⠀',
  }
  vim.g.dashboard_default_executive = 'telescope'
  vim.g.dashboard_custom_section = {
    a = {
      description = { '  Projects' },
      command = 'Telescope projects',
    },
    b = {
      description = { '  Recently Used Files' },
      command = 'Telescope frecency',
    },
    c = {
      description = { '  Find File' },
      command = 'Telescope find_files',
    },
    d = {
      description = { '  Find Word' },
      command = 'Telescope live_grep',
    },
    -- TODO
    -- e = {
    --   description = { '  Configuration      ' },
    --   command = ':e ' .. config.path,
    -- },
  }
  vim.g.dashboard_session_directory = CACHE_PATH .. '/sessions'
  require('core.autocommands').define_augroups({
    dashboard = {
      {
        'FileType',
        'dashboard',
        'setlocal nocursorline noswapfile synmaxcol& signcolumn=no norelativenumber nocursorcolumn nospell  nolist  nonumber bufhidden=wipe colorcolumn= foldcolumn=0 matchpairs= ',
      },
      {
        'FileType',
        'dashboard',
        'set showtabline=0 | autocmd BufLeave <buffer> set showtabline=' .. vim.opt.showtabline._value,
      },
      { 'FileType', 'dashboard', 'nnoremap <silent> <buffer> q :q<CR>' },
    },
  })
end

return M
