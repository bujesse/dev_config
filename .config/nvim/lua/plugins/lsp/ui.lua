local M = {}

M.symbols = function()
  vim.diagnostic.config({
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.WARN] = '',
        [vim.diagnostic.severity.HINT] = '',
        [vim.diagnostic.severity.INFO] = '',
      },
      linehl = {},
      numhl = {},
    },
  })
end

M.setup = function()
  M.symbols()
end

return M
