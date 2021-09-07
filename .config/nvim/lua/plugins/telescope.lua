local actions = require('telescope.actions')

require('telescope').setup({
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
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
    sorting_strategy = 'ascending',
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
        },
      },
    },
    live_grep = {
      additional_args = function(opts)
        if opts.mode == 'filetype_mask' then
          -- Filetype mask
          local filetype = vim.fn.input('Filetype Mask: ', '', 'customlist,bu#get_rg_type_list')
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
          return { filetype }
        end
        return {}
      end,
    },
  },
})

local opts = {
  noremap = true,
  silent = true,
}

-- Essential
vim.api.nvim_set_keymap('n', '<Leader>o', '<cmd>lua require("telescope.builtin").find_files()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>f', '<cmd>lua require("telescope.builtin").live_grep()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', opts)
vim.api.nvim_set_keymap('n', 'ga', '<cmd>lua require("telescope.builtin").lsp_code_actions()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gb', '<cmd>lua require("telescope.builtin").buffers()<CR>', opts)

-- Custom
vim.api.nvim_set_keymap(
  'n',
  '<Leader>O',
  ':Telescope find_files find_command=rg,--no-ignore,--hidden,--files<CR>',
  opts
)
vim.api.nvim_set_keymap(
  'n',
  '<Leader>F',
  '<cmd>lua require("telescope.builtin").live_grep({mode = "filetype_mask"})<CR>',
  opts
)

M = {}
function M.grep_string_visual()
  local visual_selection = require('core.utils').selected_text()
  print('Search string: ' .. visual_selection)
  require('telescope.builtin').grep_string({ search = visual_selection })
end

vim.api.nvim_set_keymap('x', '<Leader>f', '<cmd>lua require("plugins.telescope").grep_string_visual()<CR>', opts)

-- which-key mappings (used less often, so put behind a 3-char input)
require('which-key').register({
  name = '+telescope',
  r = { '<cmd>lua require("telescope.builtin").resume()<CR>', 'Resume' },
  p = { '<cmd>lua require("telescope.builtin").pickers()<CR>', 'Pickers' },
  f = { '<cmd>lua require("telescope.builtin").grep_string()<CR>', 'Grep String (under cursor)' },
  c = { '<cmd>lua require("telescope.builtin").commands()<CR>', 'Commands' },
  h = { '<cmd>lua require("telescope.builtin").command_history()<CR>', 'Command History' },
  v = { '<cmd>lua require("telescope.builtin").vim_options()<CR>', 'Vim Options' },
  o = { '<cmd>lua require("telescope.builtin").oldfiles()<CR>', 'Old Files' },
  s = { '<cmd>lua require("telescope.builtin").spell_suggest()<CR>', 'Spell Suggest (under cursor)' },
  k = { '<cmd>lua require("telescope.builtin").keymaps()<CR>', 'Keymaps' },
  a = { '<cmd>lua require("telescope.builtin").()<CR>', 'Old Files' },
  g = {
    name = '+git',
    c = { '<cmd>lua require("telescope.builtin").git_commits()<CR>', 'Git Commits' },
    b = { '<cmd>lua require("telescope.builtin").git_bcommits()<CR>', 'Git Buffer Commits' },
    r = { '<cmd>lua require("telescope.builtin").git_branches()<CR>', 'Git Branches' },
    s = { '<cmd>lua require("telescope.builtin").git_status()<CR>', 'Git Status' },
  },
}, {
  prefix = '<Leader>t',
})

return M
