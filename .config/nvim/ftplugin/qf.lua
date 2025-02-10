-- enable window-picker for quickfix window
vim.keymap.set('n', '<C-g>', function()
  local showed = require('bqf').hidePreviewWindow()
  local winid = require('window-picker').pick_window()
  if not winid then
    if showed then
      require('bqf').showPreviewWindow()
    end
    return
  end
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.fn.setqflist({}, 'r', { idx = cursor[1] })
  vim.api.nvim_set_current_win(winid)
  vim.cmd('cc')
end, { buffer = true })
