local M = {}

function M.config()
  require('gitsigns').setup({
    signs = {
      add = { hl = 'GitSignsAdd', text = '▎', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
      change = { hl = 'GitSignsChange', text = '▎', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
      delete = { hl = 'GitSignsDelete', text = '契', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
      topdelete = { hl = 'GitSignsDelete', text = '契', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
      changedelete = { hl = 'GitSignsChange', text = '▎', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        local opts = {
          buffer = bufnr,
          desc = desc or '',
        }
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']g', function()
        if vim.wo.diff then
          return ']c'
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return '<Ignore>'
      end, {
        expr = true,
      })

      map('n', '[g', function()
        if vim.wo.diff then
          return '[c'
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return '<Ignore>'
      end, {
        expr = true,
      })

      -- Actions
      map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk')
      -- map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>', '')
      map('n', '<leader>hS', gs.stage_buffer, 'Stage Buffer')
      map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo Stage Hunk')
      map('n', '<leader>hR', gs.reset_buffer, 'Reset Buffer')
      -- map('n', '<leader>hp', gs.preview_hunk, '')
      map('n', '<leader>hb', function()
        gs.blame_line({ full = true })
      end, 'Blame full')
      map('n', '<leader>hd', gs.diffthis, 'Diff')
      -- map('n', '<leader>hD', function() gs.diffthis('~') end, '')

      -- toggles
      map('n', '<leader>htd', gs.toggle_deleted, 'Toggle Deleted')
      map('n', '<leader>htw', gs.toggle_word_diff, 'Toggle Word Diff')
      map('n', '<leader>htl', gs.toggle_linehl, 'Toggle Line Diff HL')
      map('n', '<leader>htb', gs.toggle_current_line_blame, 'Toggle Current Line Blame')
      map('n', 'yog', M.toggle_line_diffs, 'Toggle Line, Word, and Deleted')

      -- from ideavim
      map('n', '<leader>-', gs.reset_hunk, 'Reset Hunk')
      map('n', '<leader>P', gs.preview_hunk, 'Preview Hunk (Twice to enter preview)')

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end,
  })
end

M.toggle_line_diffs = function()
  local gs = package.loaded.gitsigns
  gs.toggle_linehl()
  gs.toggle_word_diff()
  gs.toggle_deleted()
end

return M
