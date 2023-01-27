local M = {}

function M.config()
  vim.o.background = "dark" -- or "light" for light mode
  require("gruvbox").setup({
    undercurl = true,
    underline = true,
    bold = true,
    italic = true,
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "soft", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {
      CursorLine = { bg = '#504945' } -- make CursorLine visible af
    },
    dim_inactive = false,
    transparent_mode = false,
  })
  vim.cmd([[colorscheme gruvbox]])
end

return M
