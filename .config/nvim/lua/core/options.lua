local M = {}

M.config = function()
  local cmd = vim.cmd
  local opt = vim.opt

  vim.g.mapleader = ','

  -- scriptencoding utf-8

  -- filetype plugin indent on
  opt.autoindent = true
  opt.autoread = true
  opt.backspace = { 'indent', 'eol,start' }
  opt.belloff = 'all'

  -- Wrap long lines with indentation
  opt.breakindent = true
  opt.breakindentopt = 'shift:2'
  opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect' }

  -- more space in the neovim command line for displaying messages
  opt.cmdheight = 2

  -- Ask for confirmation when handling unsaved or read-only files
  opt.confirm = true
  opt.encoding = 'UTF-8'

  -- Sexy folds
  cmd([[set foldmethod=expr]])
  cmd([[set foldexpr=nvim_treesitter#foldexpr()]])
  opt.foldtext =
    [[ substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)' ]]
  -- opt.fillchars = 'fold: '
  opt.foldlevelstart = 99 -- Start with no folds
  opt.foldnestmax = 3

  -- Always do global substitutes
  opt.gdefault = true

  -- Switch to another buffer without writing or abandoning changes
  opt.hidden = true

  -- Keep 200 changes of undo history
  opt.history = 200
  opt.hlsearch = true
  opt.ignorecase = true
  opt.incsearch = true

  -- Smart casing when completing
  opt.infercase = true

  cmd([[set iskeyword-=#]])

  -- We want a statusline
  opt.laststatus = 2
  opt.lazyredraw = true
  opt.mouse = 'a'

  -- Hide the line terminating character
  opt.cursorline = true

  -- DO NOT TURN ON. DUPES LINES ON FORMAT
  -- opt.nofixendofline

  -- No to double-spaces when joining lines
  opt.joinspaces = false

  -- Makes it a little faster
  opt.showcmd = false

  -- No jumping cursors when matching pairs
  -- opt.showmatch = false
  opt.showmode = false

  -- No backup files
  opt.swapfile = false

  -- Relative numbering (toggle with yor)
  opt.relativenumber = true
  opt.number = true
  opt.pumheight = 15
  opt.pumblend = 15

  -- Somehow this makes syntax highlighting in vim 100x faster
  -- opt.regexpengine=1

  -- Start scrolling when we're 8 lines away from margins
  opt.scrolloff = 8

  -- Using this to persist buffer locations https://github.com/akinsho/bufferline.nvim#configuration
  cmd([[set sessionoptions+=globals]])
  -- opt.sessionoptions=blank,curdir,tabpages,winpos,globals

  -- Use this to wrap long lines
  opt.showbreak = '↳'
  opt.sidescroll = 1

  -- always render the sign column to prevent shifting
  opt.signcolumn = 'yes'
  opt.smartcase = true
  opt.smarttab = true
  opt.splitright = true
  opt.splitbelow = true
  -- opt.colorcolumn = '99999'
  opt.synmaxcol = 200
  opt.tabstop = 4
  opt.shiftwidth = 4
  opt.expandtab = true
  opt.softtabstop = 4

  -- Enable 24-bit color support for terminal Vim
  opt.termguicolors = true

  -- No auto-newline
  opt.textwidth = 0
  opt.wrapmargin = 0
  opt.timeoutlen = 500
  opt.ttimeoutlen = 10

  -- opt.the persistent undo directory on temporary private fast storage.
  opt.undofile = true
  opt.updatetime = 150

  -- Defines the trigger for 'wildmenu' in mappings
  -- opt.wildcharm = '<Tab>'

  -- Ignore certain files and folders when globing
  cmd([[
  set wildignore+=*.o,*.obj,*.bin,*.dll,*.exe
  set wildignore+=*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**
  set wildignore+=*.jpg,*.png,*.jpeg,*.bmp,*.gif,*.tiff,*.svg,*.ico
  set wildignore+=*.pyc
  set wildignore+=*.DS_Store
  set wildignore+=*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz,*.xdv
  ]])

  -- ignore file and dir name cases in cmd-completion
  opt.wildignorecase = true

  -- Nice command completions
  opt.wildmenu = true

  -- Complete the next full match
  opt.wildmode = 'full'
end

return M
