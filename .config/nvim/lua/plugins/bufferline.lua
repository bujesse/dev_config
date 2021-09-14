local M = {}

M.config = function()
  vim.opt.termguicolors = true
  require('bufferline').setup({
    offsets = {
      {
        filetype = 'NvimTree',
        text = 'File Explorer',
        highlight = 'Directory',
        text_align = 'left',
      },
    },
    persist_buffer_sort = true,
    separator_style = { 'thin', 'slant' },
  })

  vim.api.nvim_set_keymap('n', 'L', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'H', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'gb', ':BufferLinePick<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-Left>', ':BufferLineMovePrev<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-Right>', ':BufferLineMoveNext<CR>', { noremap = true, silent = true })

  vim.api.nvim_set_keymap('n', '<Leader>bl', ':BufferLineCloseRight<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>bh', ':BufferLineCloseLeft<CR>', { noremap = true, silent = true })

  vim.api.nvim_set_keymap('n', '<Leader>be', ':BufferLineSortByExtension<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>bd', ':BufferLineSortByDirectory<CR>', { noremap = true, silent = true })
end

return M
