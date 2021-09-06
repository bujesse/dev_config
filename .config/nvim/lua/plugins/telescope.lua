local actions = require('telescope.actions')

-- gets the --type-list from 'rg' and filters it based on input string
vim.api.nvim_command [[
fun GetRgTypeList(ArgLead, CmdLine, CursorPos)
let opts = system('rg --type-list')
return filter(split(opts, '\n'), {idx, val -> val =~ a:ArgLead})
endfun
]]

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-n>'] = actions.cycle_history_next,
        ['<C-p>'] = actions.cycle_history_prev,
        ['<esc>'] = actions.close,
      },
    },
    layout_strategy = 'vertical',
    layout_config = {
      vertical = {
        mirror = true,
      },
    },
    file_ignore_patterns = {
      '.git/',
      'node_modules/',
      'package-lock.json',
      'plug.vim',
      'plug.vim.old',
    },
    cache_picker = {
      num_pickers = 5,
    },
  },
  pickers = {
    lsp_references = {
      layout_config = {
        vertical = {
          width = 0.6,
          height = 0.6,
        }
      }
    },
    live_grep = {
      additional_args = function(opts)
        if opts.opt == 'filetype_mask' then
          -- Filetype mask
          local filetype = vim.fn.input("Filetype Mask: ", "", "customlist,GetRgTypeList")
          if filetype == '' then
            return {}
          end
          local colon_idx = string.find(filetype, ':', 1, true)
          if colon_idx ~= nil then
            filetype = string.sub(filetype, 1, colon_idx - 1)
          end
          filetype = '-t' .. filetype
          vim.api.nvim_command('redraw')
          print('Using rg additional arg: ' .. filetype)
          return {filetype}
        end
        return {}
      end
    }
  }
}

local opts = {
  noremap=true,
  silent=true,
}

-- Essential
vim.api.nvim_set_keymap('n', '<Leader>o', '<cmd>lua require("telescope.builtin").find_files()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>f', '<cmd>lua require("telescope.builtin").live_grep()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', opts)
vim.api.nvim_set_keymap('n', 'ga', '<cmd>lua require("telescope.builtin").lsp_code_actions()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', opts)

-- Custom
vim.api.nvim_set_keymap('n', '<Leader>O', ':Telescope find_files find_command=rg,--ignore,--hidden,--files<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>F', '<cmd>lua require("telescope.builtin").live_grep({opt = "filetype_mask"})<CR>', opts)

-- which-key mappings (used less often, so put behind a 3-char input)
require("which-key").register({
  name = '+telescope',
  r = {'<cmd>lua require("telescope.builtin").resume()<CR>', 'Resume'},
  p = {'<cmd>lua require("telescope.builtin").pickers()<CR>', 'Pickers'},
  f = {'<cmd>lua require("telescope.builtin").grep_string()<CR>', 'Grep String (under cursor)'},
  c = {'<cmd>lua require("telescope.builtin").commands()<CR>', 'Commands'},
  h = {'<cmd>lua require("telescope.builtin").command_history()<CR>', 'Command History'},
  v = {'<cmd>lua require("telescope.builtin").vim_options()<CR>', 'Vim Options'},
  o = {'<cmd>lua require("telescope.builtin").oldfiles()<CR>', 'Old Files'},
  s = {'<cmd>lua require("telescope.builtin").spell_suggest()<CR>', 'Spell Suggest (under cursor)'},
  k = {'<cmd>lua require("telescope.builtin").keymaps()<CR>', 'Keymaps'},
  b = {'<cmd>lua require("telescope.builtin").buffers()<CR>', 'Buffers'},
  g = {
    name = "+git",
    c = {'<cmd>lua require("telescope.builtin").git_commits()<CR>', 'Git Commits'},
    b = {'<cmd>lua require("telescope.builtin").git_bcommits()<CR>', 'Git Buffer Commits'},
    r = {'<cmd>lua require("telescope.builtin").git_branches()<CR>', 'Git Branches'},
    s = {'<cmd>lua require("telescope.builtin").git_status()<CR>', 'Git Status'},
  },
}, { prefix = "<Leader>t" })
