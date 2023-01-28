local M = {}

function M.config()
  require("nvim-surround").setup({
    aliases = {
      ["q"] = { '"', "'", "`" },
      ["b"] = { ')', "}", "]" },
    },
    move_cursor = false,
  })
end

return M
