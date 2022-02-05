local M = {}
local bufferline = require('bufferline')

M.intellij_close = function()
  -- Close current buffer and cycle left.
  -- If current buffer is the leftmost buffer, then cycle right.
  local current_buf_num = vim.fn.winbufnr(0)
  bufferline.buf_exec(1, function(current_buf, visible_buffers)
    for _, buf in ipairs(visible_buffers) do
      if buf and buf.id == current_buf_num then
        if buf.ordinal == 1 then
          bufferline.cycle(1)
        else
          bufferline.cycle(-1)
        end
        vim.cmd('bdelete! ' .. current_buf_num)
        break
      end
    end
  end)
end

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
  vim.api.nvim_set_keymap(
    'n',
    'X',
    '<cmd>lua require"plugins.bufferline".intellij_close()<CR>',
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
