require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "o", "<2-LeftMouse>" },
    open = "<CR>",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  sidebar = {
    open_on_start = true,
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
      { id = "stacks", size = 0.15 },
      { id = "breakpoints", size = 0.25 },
      {
        id = "scopes",
        size = 0.25, -- Can be float or integer > 1
      },
      { id = "watches", size = 0.35 },
    },
    width = 40,
    position = "left", -- Can be "left" or "right"
  },
  tray = {
    open_on_start = false,
    elements = { "repl" },
    height = 5,
    position = "bottom", -- Can be "bottom" or "top"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})

local opts = {
  noremap=true,
  silent=true,
}

vim.api.nvim_set_keymap('n', '<Space>t', ":lua require'dapui'.toggle('tray')<CR>", opts)
vim.api.nvim_set_keymap('n', '<Space>s', ":lua require'dapui'.toggle('sidebar')<CR>", opts)

vim.api.nvim_set_keymap('n', '<Space>e', ":lua require'dapui'.eval()<CR>", opts)
vim.api.nvim_set_keymap('v', '<Space>e', ":lua require'dapui'.eval()<CR>", opts)
