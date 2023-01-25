local M = {}

function M.config()
  require("scrollbar").setup()
  require("scrollbar.handlers.gitsigns").setup()
end

return M
