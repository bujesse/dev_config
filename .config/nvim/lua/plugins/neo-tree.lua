local M = {}

function M.config()
  vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

  vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
  vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
  vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
  vim.fn.sign_define('DiagnosticSignHint', { text = ' ', texthl = 'DiagnosticSignHint' })

  require('neo-tree').setup({
    popup_border_style = 'NC',
    close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
    nesting_rules = {},
    buffers = {
      follow_current_file = false, -- This will find and focus the file in the active buffer every time the current file is changed while the tree is open.
    },
    event_handlers = {
      {
        -- Auto close on Open File
        event = 'file_opened',
        handler = function(file_path)
          --auto close
          require('neo-tree').close_all()
        end,
      },
    },
    default_component_configs = {
      modified = {
        symbol = '[+]',
        highlight = 'NeoTreeModified',
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = 'NeoTreeFileName',
      },
      git_status = {
        symbols = {
          -- Change type
          added = '', -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
          deleted = '✖', -- this can only be used in the git_status source
          renamed = '', -- this can only be used in the git_status source
          -- Status type
          untracked = '',
          ignored = '',
          unstaged = '',
          staged = '',
          conflict = '',
        },
      },
    },
    window = {
      mappings = {
        ['l'] = {
          'toggle_node',
          nowait = true, -- disable `nowait` if you have existing combos starting with this char that you want to use
        },
        -- ['l'] = 'open_node',
        ['h'] = 'close_node',
        ['/'] = 'filter_on_submit',
        ['f'] = 'fuzzy_finder',
      },
    },
    filesystem = {
      window = {
        mappings = {
          ['<space>f'] = 'telescope_grep', -- Override mapping to search only in the current directory or file highlighted in neo-tree
        },
      },
      commands = {
        -- telescope_find = function(state)
        --   local node = state.tree:get_node()
        --   local path = node:get_id()
        --   require('telescope.builtin').find_files(getTelescopeOpts(state, path))
        -- end,
        telescope_grep = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          P(path)
          require('telescope.builtin').live_grep({ cwd = path })
        end,
      },
      components = {
        harpoon_index = function(config, node, state)
          local Marked = require('harpoon.mark')
          local path = node:get_id()
          local succuss, index = pcall(Marked.get_index_of, path)
          if succuss and index and index > 0 then
            return {
              text = string.format(' %d', index), -- <-- Add your favorite harpoon like arrow here
              highlight = config.highlight or 'NeoTreeDirectoryIcon',
            }
          else
            return {}
          end
        end,
      },
      renderers = {
        file = {
          { 'icon' },
          { 'name', use_git_status_colors = true },
          { 'harpoon_index' }, --> This is what actually adds the component in where you want it
          { 'diagnostics' },
          { 'git_status', highlight = 'NeoTreeDimText' },
        },
      },
    },
    git_status = {
      window = {
        position = 'float',
        mappings = {
          ['A'] = 'git_add_all',
          ['gu'] = 'git_unstage_file',
          ['ga'] = 'git_add_file',
          ['gr'] = 'git_revert_file',
          ['gc'] = 'git_commit',
          ['gp'] = 'git_push',
          ['gg'] = 'git_commit_and_push',
        },
      },
    },
  })

  require('which-key').register({
    name = 'Neotree',
    n = { ':Neotree source=filesystem toggle=true<CR>', 'Open Neotree' },
    N = { ':Neotree source=filesystem reveal=true<CR>', 'Open Neotree and find file' },
    g = {
      ':Neotree source=git_status position=float toggle=true reveal=true<CR>',
      'Open git status Neotree in a float',
    },
  }, {
    prefix = '<Leader>',
  })
end

return M
