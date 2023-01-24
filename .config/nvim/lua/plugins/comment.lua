local M = {}

function M.config()
  -- `gco` - Insert comment to the next line and enters INSERT mode
  -- `gcO` - Insert comment to the previous line and enters INSERT mode
  -- `gcA` - Insert comment to end of the current line and enters INSERT mode
  require('Comment').setup({
    ignore = '^$',
    toggler = {
      block = 'gcb',
    },
    opleader = {
      block = 'gcb',
    },
  })
end

return M
