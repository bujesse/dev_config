local M = {}

function M.config()
  require('neoclip').setup({
    -- enable_persistent_history = true,
  })
  vim.keymap.set('n', '<Space>y',
    [[:lua require("telescope").extensions.neoclip.default({ sorting_strategy = "ascending", layout_strategy = "cursor", results_title = false, layout_config = { width = 0.8, height = 0.4, } })<CR>]])
end

return M
