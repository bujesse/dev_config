local M = {}

M.config = function()
  require('nvim-autopairs').setup({})
  -- require('nvim-autopairs.completion.cmp').setup({
  --   map_cr = true, -- map <CR> on insert mode
  --   map_complete = true, -- it will auto insert `(` after select function or method item
  --   insert = false, -- use insert confirm behavior instead of replace
  --   auto_select = true, -- automatically select the first item
  -- })
end

return M
