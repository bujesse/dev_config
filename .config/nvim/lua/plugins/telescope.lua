-- nnoremap <silent> <Leader>o :Files<CR>
-- nnoremap <silent> <Leader>f :RG<CR>
-- nnoremap <silent> <Leader>g :GFiles?<CR>
-- nnoremap <silent> <Leader>hh :History<CR>
-- nnoremap <silent> <Leader>hc :History:<CR>
-- nnoremap <silent> <Leader>hs :History/<CR>

local actions = require('telescope.actions')

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
  },
}

local opts = {
  noremap=true,
  silent=true,
}

vim.api.nvim_set_keymap('n', '<Leader>o', '<cmd>lua require("telescope.builtin").find_files()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>f', '<cmd>lua require("telescope.builtin").live_grep()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>s', '<cmd>lua require("telescope.builtin").grep_string()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gh', '<cmd>lua require("telescope.builtin").lsp_code_actions()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', opts)

