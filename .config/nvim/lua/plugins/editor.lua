return {
  -- file explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      's1n7ax/nvim-window-picker',
    },
    branch = 'v2.x',
    opts = {
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
          ['h'] = 'close_node',
          ['<C-v>'] = 'open_vsplit',
          ['<C-x>'] = 'open_split',
          ['<C-t>'] = 'open_tabnew',
          -- ['/'] = 'filter_on_submit',
          -- ['f'] = 'fuzzy_finder',
        },
      },
      filesystem = {
        window = {
          mappings = {
            ['<space>f'] = 'telescope_grep', -- Override mapping to search only in the current directory or file highlighted in neo-tree
          },
        },
        commands = {
          telescope_grep = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            P(path)
            require('telescope.builtin').live_grep({ cwd = path })
          end,
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
    },
    keys = {
      { '<Leader>n', ':Neotree source=filesystem toggle=true<CR>', 'Open Neotree' },
      { '<Leader>N', ':Neotree source=filesystem reveal=true<CR>', 'Open Neotree and find file' },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
  },

  -- which-key
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    opts = {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
          enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
          operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = false, -- adds help for motions
          text_objects = false, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
      operators = { gc = 'Comments' },
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { 'j', 'k', 'J', 'K' },
        v = { 'j', 'k' },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["cr"] = { name = '+abolish coerce word', },
        -- ["ys"] = { name = "+surround" },
        -- ["<leader><tab>"] = { name = "+tabs" },
        -- ["<leader>b"] = { name = "+buffer" },
        -- ["<leader>c"] = { name = "+code" },
        -- ["<leader>f"] = { name = "+file/find" },
        -- ["<leader>g"] = { name = "+git" },
        -- ["<leader>gh"] = { name = "+hunks" },
        -- ["<leader>q"] = { name = "+quit/session" },
        -- ["<leader>s"] = { name = "+search" },
        -- ["<leader>sn"] = { name = "+noice" },
        -- ["<leader>u"] = { name = "+ui" },
        -- ["<leader>w"] = { name = "+windows" },
        -- ["<leader>x"] = { name = "+diagnostics/quickfix" },
      })
    end,
  },

  -- git signs
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      {
        'petertriho/nvim-scrollbar',
        config = function()
          require("scrollbar").setup()
          require("scrollbar.handlers.gitsigns").setup()
        end,
      },
    },
    event = "BufReadPre",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
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

        local function toggle_line_diffs()
          gs.toggle_linehl()
          gs.toggle_word_diff()
          gs.toggle_deleted()
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
        map('n', 'yog', toggle_line_diffs, 'Toggle Line, Word, and Deleted')

        -- from ideavim
        map('n', '<leader>-', gs.reset_hunk, 'Reset Hunk')
        map('n', '<leader>P', gs.preview_hunk, 'Preview Hunk (Twice to enter preview)')

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
    },
  },

  -- fugitive
  {
    'tpope/vim-fugitive',
    keys = {
      { '<Leader>B', 'Git blame', desc = 'Git Blame' },
      { '<Leader>g', '<Cmd>tab G<Cr>', 'Open Fugitive Status' },
    },
    cmd = { 'Git' },
    init = function()
      vim.cmd([[command BuCloseFugitive silent call CloseAllTabsWithFiletype('fugitive')]])
    end
  },

  -- diff view
  {
    'sindrets/diffview.nvim',
    enabled = false,
    opts = function()
      local actions = require('diffview.actions')
      return {
        enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
        keymaps = {
          view = {},
          file_panel = {
            { 'n', 'x', actions.help('file_panel'), { desc = 'Open the help panel' } },
            { 'n', 'r', actions.refresh_files, { desc = 'Refresh files' } },
            { 'n', '<Space>', actions.toggle_stage_entry, { desc = 'Stage / unstage the selected entry.' } },
            { 'n', 'e', actions.goto_file, { desc = 'Edit the file in a new split in the previous tabpage' } },
          },
        },
      }
    end,
    keys = {
      { '<Leader>gg', '<Cmd>DiffviewOpen<Cr>' }
    },
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    },
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    config = true,
    -- stylua: ignore
    keys = {
      { "]x", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[x", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    },
  },

  -- symbols outline
  {
    'simrat39/symbols-outline.nvim',
    opts = {
      keymaps = {
        close = { '<Esc>', 'q' },
        goto_location = '<Cr>',
        focus_location = 'o',
        hover_symbol = 'gh',
        toggle_preview = 'P',
        rename_symbol = 'r',
        code_actions = 'a',
        fold = 'h',
        unfold = 'l',
        fold_all = 'W',
        unfold_all = 'E',
        fold_reset = 'R',
      },
    },
    keys = {
      { '<Leader>2', '<Cmd>SymbolsOutline<CR>', desc = 'Symbols Outline' }
    },
    init = function()
      local augroup = vim.api.nvim_create_augroup('CustomSymbolsOutline', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
        group = augroup,
        pattern = 'Outline',
        command = 'set foldcolumn=0',
      })
    end
  },

  -- harpoon
  {
    'ThePrimeagen/harpoon',
    keys = {
      { '<Leader>ma', function()
        require("harpoon.mark").add_file()
        local filename = vim.api.nvim_buf_get_name(0)
        print('Harpoon Add: ' .. filename)
      end },
      { '<Leader>mm', ':lua require("harpoon.ui").toggle_quick_menu()<CR>' },
      { '<Leader>m1', ':lua require("harpoon.ui").nav_file(1)<CR>' },
      { '<Leader>m2', ':lua require("harpoon.ui").nav_file(2)<CR>' },
      { '<Leader>m3', ':lua require("harpoon.ui").nav_file(3)<CR>' },
      { '<Leader>m4', ':lua require("harpoon.ui").nav_file(4)<CR>' },
      { '<Leader>m5', ':lua require("harpoon.ui").nav_file(5)<CR>' },
      { '<Leader>m6', ':lua require("harpoon.ui").nav_file(6)<CR>' },
      { '<Leader>m7', ':lua require("harpoon.ui").nav_file(7)<CR>' },
      { '<Leader>m8', ':lua require("harpoon.ui").nav_file(8)<CR>' },
      { '<Leader>m9', ':lua require("harpoon.ui").nav_file(9)<CR>' },
    },
  },

  -- better quickfix
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf', -- filetype: quickfix
    dependencies = {
      {
        'junegunn/fzf',
        build = function()
          vim.fn['fzf#install']()
        end,
      },
    },
    opts = {
      auto_resize_height = true,
      func_map = {
        drop = 'o',
        tabdrop = 't',
        ptoggleitem = 'P',
        ptogglemode = 'zp',
        prevhist = '<',
        nexthist = '>',
        stogglebuf = "'<Tab>", -- toggle signs for same buffers under the cursor
        sclear = 'z<Tab>', -- clear the signs in current quickfix list
        fzffilter = '/',
        filter = 'f', -- create new list for signed items
        filterr = 'F', -- create new list for non-signed items
      },
      filter = {
        fzf = {
          action_for = {
            ['enter'] = 'signtoggle',
          },
          extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ' }
        }
      }
    },
  },

  -- search/replace in multiple files
  {
    "windwp/nvim-spectre",
    -- stylua: ignore
    keys = {
      { "<leader>r", function() require("spectre").open({ is_insert_mode = true, })
      end, desc = "Replace in files (Spectre)" },
    },
  },
}
