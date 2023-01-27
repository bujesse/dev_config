local M = {}

function M.config()
  local utils = require('yanky.utils')
  local mapping = require('yanky.telescope.mapping')
  require('yanky').setup({
    highlight = {
      on_put = false,
      on_yank = false,
      timer = 300,
    },
    system_clipboard = {
      sync_with_ring = false,
    },
    preserve_cursor_position = {
      enabled = true
    },
    picker = {
      telescope = {
        mappings = {
          default = mapping.set_register(utils.get_default_register()),
        }
      }
    }
  })
  vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
  vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
  vim.keymap.set({ 'n', 'x' }, ']p', '<Plug>(YankyPutIndentAfterLinewise)')
  vim.keymap.set({ 'n', 'x' }, '[p', '<Plug>(YankyPutIndentBeforeLinewise)')
  vim.keymap.set('n', '[y', '<Plug>(YankyCycleForward)')
  vim.keymap.set('n', ']y', '<Plug>(YankyCycleBackward)')
  vim.keymap.set({ 'n', 'x' }, 'y', '<Plug>(YankyYank)')
  vim.keymap.set('n', '<Space>y',
    ':lua require("telescope").extensions.yank_history.yank_history({ sorting_strategy = "ascending", layout_strategy = "cursor", results_title = false, layout_config = { width = 0.8, height = 0.4, } })<cr>')
end

return M
