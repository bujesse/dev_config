local M = {}

function M.config()
  -- vim.cmd([[highlight IndentBlanklineIndent1 guifg=#61AFEF blend=nocombine]])
  -- vim.cmd([[highlight IndentBlanklineIndent2 guifg=#C678DD blend=nocombine]])
  -- https://github.com/lukas-reineke/indent-blankline.nvim/blob/master/lua/indent_blankline/init.lua

  require('indent_blankline').setup({
    buftype_exclude = { 'dashboard', 'terminal', 'nofile' },
    -- char_list = { '│', '¦' },
    -- char = '▏',
    -- context_char = '▏',
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
    show_current_context = true,
    show_current_context_start = false,
    filetype_exclude = {
      'help',
      'startify',
      'dashboard',
      'lazy',
      'neogitstatus',
      'NvimTree',
      'Trouble',
      'text',
    },
  })
end

return M
