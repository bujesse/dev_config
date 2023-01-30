local actions = require('diffview.actions')

local M = {}

function M.config()
  require('diffview').setup({
    enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
    keymaps = {
      view = {},
      file_panel = {
        { 'n', 'x', actions.help('file_panel'), { desc = 'Open the help panel' } },
        { 'n', 'r', actions.refresh_files, { desc = '[R]efresh files' } },
        { 'n', '<Space>', actions.toggle_stage_entry, { desc = 'Stage / unstage the selected entry.' } },
        { 'n', 'e', actions.goto_file, { desc = '[E]dit the file in a new split in the previous tabpage' } },
      },
    },
  })

  vim.keymap.set('n', '<Leader>gg', '<Cmd>DiffviewOpen<Cr>')
end

return M
