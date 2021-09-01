-- vim.cmd [[highlight IndentBlanklineIndent1 guifg=#61AFEF blend=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent2 guifg=#C678DD blend=nocombine]]
-- https://github.com/lukas-reineke/indent-blankline.nvim/blob/master/lua/indent_blankline/init.lua

require('indent_blankline').setup {
  buftype_exclude = {'startify', 'terminal'},
  char_list = {'│', '¦'}
  -- char_highlight_list = {
  --   'IndentBlanklineIndent1',
  --   'IndentBlanklineIndent2',
  -- },
}
