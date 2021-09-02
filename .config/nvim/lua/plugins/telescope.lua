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
    file_ignore_patterns = {'.git/', 'node_modules/', 'package-lock.json'},
  },
  pickers = {
    live_grep = {
      additional_args = function(opts)
        if opts.opt == 'filetype_mask' then
          -- Filetype mask
          local filetype = vim.fn.input("Filetype Mask: ", "", "customlist,GetRgTypeList")
          if filetype == '' then
            return {}
          end
          colon_idx = string.find(filetype, ':', 1, true)
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

vim.api.nvim_set_keymap('n', '<Leader>o', '<cmd>lua require("telescope.builtin").find_files()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>f', '<cmd>lua require("telescope.builtin").live_grep()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>s', '<cmd>lua require("telescope.builtin").grep_string()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gh', '<cmd>lua require("telescope.builtin").lsp_code_actions()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', opts)

vim.api.nvim_set_keymap('n', '<Leader>O', ':Telescope find_files find_command=rg,--ignore,--hidden,--files<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>F', '<cmd>lua require("telescope.builtin").live_grep({opt = "filetype_mask"})<CR>', opts)

