local M = {}

function M.config()
  vim.api.nvim_set_keymap('v', '<sc-c>', '"+y', { noremap = true }) -- Select line(s) in visual mode and copy (CTRL+Shift+V)
  vim.api.nvim_set_keymap('i', '<sc-v>', '<ESC>"+p', { noremap = true }) -- Paste in insert mode (CTRL+Shift+C)
  vim.api.nvim_set_keymap('n', '<sc-v>', '"+p', { noremap = true }) -- Paste in normal mode (CTRL+Shift+C)

  vim.g.neovide_cursor_animation_length = 0.1
  vim.g.neovide_cursor_trail_size = 0.5

  vim.g.neovide_cursor_animate_command_line = false

  vim.g.neovide_cursor_vfx_mode = 'sonicboom'

  vim.g.neovide_cursor_smooth_blink = false
end

return M
