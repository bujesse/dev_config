return {
  -- dashboard
  {
    'mhinz/vim-startify',
    config = function()
      vim.g.ascii = {
        '███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
        '████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
        '██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
        '██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
        '██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
        '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
        '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
        '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
      }

      vim.g.startify_bookmarks = {
        { gt = '~/dev_config/.config/tmuxp' },
        { gT = '~/dev_config/.config/tmux/tmux.conf' },
        { gn = '~/dev_config/.config/nvim/init.lua' },
        { gi = '~/.ideavimrc' },
        { gz = '~/.zshrc' },
        { gh = '~/dev_config/mac_to_windows.ahk' },
        { ga = '/mnt/c/Users/Jesse/AppData/Roaming/alacritty/alacritty.yml' },
        { gf = '~/dev_config/.config/fish/config.fish' },
        { gr = '~/dev_config/README.md' },
      }

      vim.g.startify_commands = {
        { f = { '  Find Word', 'Telescope live_grep' } },
        { o = { '  Find File', 'Telescope find_files' } },
        { lc = { '  Check Plugins', 'Lazy check' } },
        { ls = { '  Sync Plugins (Lazy install, clean, update)', 'Lazy sync' } },
        { ts = { '  Update Treesitter', 'TSUpdateSync' } },
        { D = { '  Diff View', 'DiffviewOpen' } },
        { G = { '  Git (Fugitive)', 'G' } },
        { ch = { '  Check Health', 'checkhealth' } },
        { m = { '  Mason', 'Mason' } },
        { L = { '🧑‍🎓  Leetcode', 'Leet' } },
      }

      vim.g.startify_lists = {
        { type = 'sessions', header = { '  Sessions' } },
        { type = 'bookmarks', header = { '  Bookmarks' } },
        { type = 'commands', header = { '  Commands' } },
        { type = 'files', header = { '  Recent Files' } },
      }

      vim.g.startify_session_autoload = 1
      vim.g.startify_change_to_vcs_root = 1
      vim.g.startify_session_sort = 1
      vim.g.startify_session_persistence = 1
      vim.g.startify_session_dir = CACHE_PATH .. '/sessions'

      -- Help texts should not be added to the session
      vim.g.startify_session_before_save = {
        'silent! helpclose',
        'silent! cclose',
        'silent! SymbolsOutlineClose',
        'silent! BuCloseDiffview',
        'silent! BuCloseFugitive',
      }

      -- barbar doesn't load immediately because it
      -- ignores the autocommands while SessionLoad is set
      vim.g.startify_session_remove_lines = { 'unlet SessionLoad' }
      vim.g.startify_session_savecmds = {
        'unlet SessionLoad',
      }

      vim.g.startify_custom_header = 'startify#pad(g:ascii + startify#fortune#boxed())'

      -- Save and load sessions
      -- vim.api.nvim_set_keymap('n', '<F5>', ':SSave!<CR>', { noremap = true, silent = true })
      -- vim.api.nvim_set_keymap('n', '<F8>', ':SLoad<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>ss', ':Startify<CR>', { noremap = true, silent = true })

      -- require('core.autocommands').define_augroups({
      --   _startify = {
      --     -- seems to be nobuflisted that makes my stuff disappear will do more testing
      --     {
      --       'FileType',
      --       'startify',
      --       'setlocal nocursorline noswapfile synmaxcol& signcolumn=no norelativenumber nocursorcolumn nospell  nolist  nonumber bufhidden=wipe colorcolumn= foldcolumn=0 matchpairs= ',
      --     },
      --     {
      --       'FileType',
      --       'startify',
      --       'set showtabline=0 | autocmd BufLeave <buffer> set showtabline=' .. vim.opt.showtabline._value,
      --     },
      --   },
      -- })
    end,
  },
}
