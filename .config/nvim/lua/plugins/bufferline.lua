local M = {}
local bufferline = require('bufferline')

M.config = function()
  bufferline.setup({
    options = {
      middle_mouse_command = function(bufnum)
        vim.cmd('bdelete! ' .. bufnum)
      end,
      offsets = {
        {
          filetype = 'NvimTree',
          text = 'Nvim Tree',
          highlight = 'Directory',
          text_align = 'left',
        },
      },
      persist_buffer_sort = true,
      groups = {
        options = {
          toggle_hidden_on_enter = true, -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
        },
        items = {
          require('bufferline.groups').builtin.ungrouped, -- ungrouped comes before groups
          {
            name = 'Tests',
            -- highlight = {gui = "underline", },
            priority = 1,
            icon = '', -- Optional
            matcher = function(buf)
              return buf.filename:match('%_test') or buf.filename:match('%_spec')
            end,
          },
          {
            name = 'Docs',
            -- highlight = {gui = "undercurl", },
            auto_close = false, -- whether or not close this group if it doesn't contain the current buffer
            priority = 2,
            matcher = function(buf)
              return buf.filename:match('%.md') or buf.filename:match('%.txt')
            end,
          },
        },
      },
    },
  })

  vim.api.nvim_set_keymap('n', 'L', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'H', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-Left>', ':BufferLineMovePrev<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-Right>', ':BufferLineMoveNext<CR>', { noremap = true, silent = true })

  vim.api.nvim_set_keymap('n', 'gb', ':BufferLinePick<CR>', { noremap = true, silent = true })

  vim.api.nvim_set_keymap('n', '<Leader>be', ':BufferLineSortByExtension<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>bd', ':BufferLineSortByDirectory<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>bd', ':BufferLineSortByDirectory<CR>', { noremap = true, silent = true })

  vim.api.nvim_set_keymap('n', '<Leader>bl', ':BufferLineCloseRight<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>bh', ':BufferLineCloseLeft<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'X', ':BufDel<CR>', { noremap = true, silent = true })
end

return M
