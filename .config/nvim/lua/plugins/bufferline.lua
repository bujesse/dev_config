local M = {}
local bufferline = require('bufferline')

M.chrome_close = function()
  local current_buf_num = vim.api.nvim_get_current_buf()
  bufferline.cycle(1)
  vim.cmd('bdelete! ' .. current_buf_num)
  -- bufferline.buf_exec(current_buf_num, function(buf, visible_buffers)
  --   print(current_buf_num)
  --   -- P(buf)
  --   -- P(visible_buffers)
  --   -- check if first or last, and move, then delete the old buffer
  -- end)
end

M.config = function()
  bufferline.setup({
    options = {
      offsets = {
        {
          filetype = 'NvimTree',
          text = 'Nvim Tree',
          highlight = 'Directory',
          text_align = 'left',
        },
      },
      persist_buffer_sort = true,
    },
  })

  vim.api.nvim_set_keymap('n', 'L', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'H', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap(
    'n',
    'X',
    '<cmd>lua require"plugins.bufferline".chrome_close()<CR>',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap('n', '<C-Left>', ':BufferLineMovePrev<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-Right>', ':BufferLineMoveNext<CR>', { noremap = true, silent = true })

  vim.api.nvim_set_keymap('n', 'gb', ':BufferLinePick<CR>', { noremap = true, silent = true })

  vim.api.nvim_set_keymap('n', '<Leader>be', ':BufferLineSortByExtension<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>bd', ':BufferLineSortByDirectory<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>bd', ':BufferLineSortByDirectory<CR>', { noremap = true, silent = true })

  vim.api.nvim_set_keymap('n', '<Leader>bl', ':BufferLineCloseRight<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>bh', ':BufferLineCloseLeft<CR>', { noremap = true, silent = true })
end

return M
