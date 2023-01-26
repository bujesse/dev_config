local M = {}

function M.config()
  require("nvim-surround").setup({
    aliases = {
      ["q"] = { '"', "'", "`" },
      ["b"] = { ')', "}", "]" },
    }
  })
end

return M
