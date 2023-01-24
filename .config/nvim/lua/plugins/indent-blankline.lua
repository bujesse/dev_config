local M = {}

function M.config()
  -- vim.cmd [[highlight IndentBlanklineIndent1 guifg=#61AFEF blend=nocombine]]
  -- vim.cmd [[highlight IndentBlanklineIndent2 guifg=#C678DD blend=nocombine]]
  -- https://github.com/lukas-reineke/indent-blankline.nvim/blob/master/lua/indent_blankline/init.lua

  require('indent_blankline').setup({
    buftype_exclude = { 'dashboard', 'terminal' },
    show_current_context = true, -- Uses Treesitter to show current indent
    char_list = { '│', '¦' },
    -- char_highlight_list = {
    --   'IndentBlanklineIndent1',
    --   'IndentBlanklineIndent2',
    -- },
  })

  vim.g.indent_blankline_filetype_exclude = {
    'help',
    'startify',
    'dashboard',
    'lspinfo',
    'NvimTree',
    'floaterm',
    'floats',
  }
end

return M
