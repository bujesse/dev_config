local M = {}

function M.config()
  vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

  vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
  vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
  vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
  vim.fn.sign_define('DiagnosticSignHint', { text = ' ', texthl = 'DiagnosticSignHint' })

  require('neo-tree').setup({
    close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
    nesting_rules = {},
    buffers = {
      follow_current_file = false, -- This will find and focus the file in the active buffer every time the current file is changed while the tree is open.
    },
    default_component_configs = {
      modified = {
        symbol = "[+]",
        highlight = "NeoTreeModified",
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = "NeoTreeFileName",
      },
      git_status = {
        symbols = {
          -- Change type
          added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
          deleted   = "✖", -- this can only be used in the git_status source
          renamed   = "", -- this can only be used in the git_status source
          -- Status type
          untracked = "",
          ignored   = "",
          unstaged  = "",
          staged    = "",
          conflict  = "",
        }
      },
    },
    window = {
      mappings = {
        ['o'] = {
          'toggle_node',
          nowait = true, -- disable `nowait` if you have existing combos starting with this char that you want to use
        }
      }
    },
    git_status = {
      window = {
        position = 'float',
        mappings = {
          ['A']  = 'git_add_all',
          ['gu'] = 'git_unstage_file',
          ['ga'] = 'git_add_file',
          ['gr'] = 'git_revert_file',
          ['gc'] = 'git_commit',
          ['gp'] = 'git_push',
          ['gg'] = 'git_commit_and_push',
        }
      }
    }
  })

  require('which-key').register({
    name = 'Neotree',
    n = { ':Neotree source=filesystem toggle=true<CR>', 'Open Neotree' },
    N = { ':Neotree source=filesystem reveal=true<CR>', 'Open Neotree and find file' },
    g = { ':Neotree source=git_status position=float toggle=true reveal=true<CR>', 'Open git status Neotree in a float' },
  }, {
    prefix = '<Leader>',
  })
end

return M
