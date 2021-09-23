local M = {}
local Log = require('core.log')

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
  insert_mode = generic_opts_any,
  normal_mode = generic_opts_any,
  visual_mode = generic_opts_any,
  visual_block_mode = generic_opts_any,
  command_mode = generic_opts_any,
  term_mode = { silent = true },
}

local mode_adapters = {
  insert_mode = 'i',
  normal_mode = 'n',
  term_mode = 't',
  visual_mode = 'v',
  visual_block_mode = 'x',
  command_mode = 'c',
}

-- Set key mappings individually
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param key The key of keymap
-- @param val Can be form as a mapping or tuple of mapping and user defined opt
function M.set_keymaps(mode, key, val)
  local opt = generic_opts[mode] and generic_opts[mode] or generic_opts_any
  if type(val) == 'table' then
    opt = val[2]
    val = val[1]
  end
  vim.api.nvim_set_keymap(mode, key, val, opt)
end

-- Load key mappings for a given mode
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param keymaps The list of key mappings
function M.load_mode(mode, keymaps)
  mode = mode_adapters[mode] and mode_adapters[mode] or mode
  for k, v in pairs(keymaps) do
    M.set_keymaps(mode, k, v)
  end
end

-- Load key mappings for all provided modes
-- @param keymaps A list of key mappings for each mode
function M.load(keymaps)
  for mode, mapping in pairs(keymaps) do
    M.load_mode(mode, mapping)
  end
end

M.keys = {}

function M.config_keys()
  M.keys = {
    ---@usage change or add keymappings for insert mode
    insert_mode = {
      -- quitting insert mode
      ['jk'] = '<ESC>',
      ['Jk'] = '<ESC>',
      ['jK'] = '<ESC>',
      ['JK'] = '<ESC>',
      ['kj'] = '<ESC>',
      ['Kj'] = '<ESC>',
      ['kJ'] = '<ESC>',
      ['KJ'] = '<ESC>',

      -- Move current line / block with Alt-j/k ala vscode.
      -- ['<A-j>'] = '<Esc>:m .+1<CR>==gi',
      -- Move current line / block with Alt-j/k ala vscode.
      -- ['<A-k>'] = '<Esc>:m .-2<CR>==gi',
      -- navigation
      -- ['<A-Up>'] = '<C-\\><C-N><C-w>k',
      -- ['<A-Down>'] = '<C-\\><C-N><C-w>j',
      -- ['<A-Left>'] = '<C-\\><C-N><C-w>h',
      -- ['<A-Right>'] = '<C-\\><C-N><C-w>l',
      -- runs conditionally
      ['<C-j>'] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
      ['<C-k>'] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },

      -- muscle memory for undoing pastes
      ['<C-z>'] = 'u',
    },

    ---@usage change or add keymappings for normal mode
    normal_mode = {
      ['j'] = "<cmd>call bu#jump_direction('j')<CR>",
      ['k'] = "<cmd>call bu#jump_direction('k')<CR>",

      ['gj'] = "<cmd>call bu#float_up('j')<CR>",
      ['gk'] = "<cmd>call bu#float_up('k')<CR>",

      -- turn of search highlight
      ['<Leader>/'] = ':noh<CR>',

      -- Easier switching between files
      ['<Backspace>'] = '<C-^>',

      -- Y should behave like D and C
      ['Y'] = 'y$',

      ['^'] = 'g^',
      ['0'] = 'g0',

      -- U feels like a more natural companion to u
      ['U'] = '<C-r>',

      -- TODO: this is prime real esate
      ['Q'] = '',

      -- Center after search
      ['n'] = 'nzzzv',
      ['N'] = 'Nzzzv',

      [']p'] = { '<Plug>unimpairedPutBelow', { noremap = false } },
      ['[p'] = { '<Plug>unimpairedPutAbove', { noremap = false } },

      [']<Space>'] = { '<Plug>unimpairedBlankDown', { noremap = false } },
      ['[<Space>'] = { '<Plug>unimpairedBlankUp', { noremap = false } },

      [']e'] = { '<Plug>unimpairedMoveDown', { noremap = false } },
      ['[e'] = { '<Plug>unimpairedMoveUp', { noremap = false } },

      -- Resize with arrows
      ['<Up>'] = '<C-W>5+',
      ['<Down>'] = '<C-W>5-',
      ['<Left>'] = '<C-W>5<',
      ['<Right>'] = '<C-W>5>',

      -- Run the last command
      ['<Leader>;'] = { 'q:k', { silent = false } },

      -- Move to or create split
      ['<C-h>'] = { '<Plug>WinMoveLeft', { noremap = false } },
      ['<C-j>'] = { '<Plug>WinMoveDown', { noremap = false } },
      ['<C-k>'] = { '<Plug>WinMoveUp', { noremap = false } },
      ['<C-l>'] = { '<Plug>WinMoveRight', { noremap = false } },

      -- Source
      ['<Leader>.'] = { ':source ~/.config/nvim/init.vim<CR>', { noremap = false, silent = true } },

      -- format entire file
      ['+'] = 'gg=G<C-o>zz',

      -- Move buf to new tab
      ['<C-z>'] = { '<Plug>Zoom', { noremap = false } },

      -- Close win
      ['<C-q>'] = '<C-w>q',

      -- Replace word with last yank (repeatable)
      ['<Leader>v'] = 'ciw<C-r>0<Esc>',

      -- Replace word with last cut (repeatable)
      ['<Leader>c'] = '"_ciw<C-r>-<Esc>',

      -- Next/Prev Tab
      [']t'] = ':tabn<CR>',
      ['[t'] = ':tabp<CR>,',

      -- TODO: probably need better space mapping here
      ['<space>'] = ':',
      ['<space><space>'] = ':w<CR>,',

      -- system yank
      ['<C-y>'] = '"*y',

      -- Move current line / block with Alt-j/k a la vscode.
      -- ['<A-j>'] = ':m .+1<CR>==',
      -- ['<A-k>'] = ':m .-2<CR>==',

      -- QuickFix
      -- [']q'] = ':cnext<CR>',
      -- ['[q'] = ':cprev<CR>',
      ['<Leader>q'] = ':call QuickFixToggle()<CR>',
    },

    ---@usage change or add keymappings for terminal mode
    term_mode = {
      -- Terminal window navigation
      ['<C-h>'] = '<C-\\><C-N><C-w>h',
      ['<C-j>'] = '<C-\\><C-N><C-w>j',
      ['<C-k>'] = '<C-\\><C-N><C-w>k',
      ['<C-l>'] = '<C-\\><C-N><C-w>l',
    },

    ---@usage change or add keymappings for visual mode
    visual_mode = {
      -- Better indenting
      ['<'] = '<gv',
      ['>'] = '>gv',

      -- system yank
      ['<C-y>'] = '"*y',

      -- Replace word with last yank (repeatable)
      ['<Leader>v'] = 'c<C-r>0<Esc>',

      -- Replace word with last cut (repeatable)
      ['<Leader>c'] = '"_c<C-r>-<Esc>',

      -- Apply the 'q' register macro to the visual selection
      ['Q'] = ":'<,'>:norm @q<CR>",

      -- ["p"] = '"0p',
      -- ["P"] = '"0P',
    },

    ---@usage change or add keymappings for visual block mode
    visual_block_mode = {
      -- Move selected line / block of text in visual mode
      [']e'] = { '<Plug>unimpairedMoveSelectionDown', { noremap = false } },
      ['[e'] = { '<Plug>unimpairedMoveSelectionUp', { noremap = false } },
    },

    ---@usage change or add keymappings for command mode
    command_mode = {
      -- navigate tab completion with <c-j> and <c-k>
      -- runs conditionally
      ['<C-j>'] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
      ['<C-k>'] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },
    },
  }

  if vim.fn.has('mac') == 1 then
    M.keys.normal_mode['<A-Up>'] = M.keys.normal_mode['<C-Up>']
    M.keys.normal_mode['<A-Down>'] = M.keys.normal_mode['<C-Down>']
    M.keys.normal_mode['<A-Left>'] = M.keys.normal_mode['<C-Left>']
    M.keys.normal_mode['<A-Right>'] = M.keys.normal_mode['<C-Right>']
    Log:debug('Activated mac keymappings')
  end
end

function M.print(mode)
  print('List of default keymappings (not including which-key)')
  if mode then
    print(vim.inspect(M.keys[mode]))
  else
    print(vim.inspect(M.keys))
  end
end

function M.config()
  M.config_keys()
  M.load(M.keys)
end

return M
