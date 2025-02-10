return {
  -- file explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    enabled = false,
    dependencies = {
      's1n7ax/nvim-window-picker',
    },
    branch = 'v3.x',
    opts = function()
      local global_commands = {
        telescope_grep = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          P(path)
          require('telescope.builtin').live_grep({ cwd = path })
        end,
        -- These are all from AstroNvim https://github.com/AstroNvim/AstroNvim/blob/1e815bb2c4dd4f8991a760b6d1e7e5d253364465/lua/plugins/neo-tree.lua#L10
        system_open = function(state)
          require('astronvim.utils').system_open(state.tree:get_node():get_id())
        end,
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if (node.type == 'directory' or node:has_children()) and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node.type == 'directory' or node:has_children() then
            if not node:is_expanded() then -- if unexpanded, expand
              state.commands.toggle_node(state)
            else -- if expanded and has children, seleect the next child
              require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1])
            end
          else -- if not a directory just open it
            state.commands.open(state)
          end
        end,
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local results = {
            e = { val = modify(filename, ':e'), msg = 'Extension only' },
            f = { val = filename, msg = 'Filename' },
            F = { val = modify(filename, ':r'), msg = 'Filename w/o extension' },
            h = { val = modify(filepath, ':~'), msg = 'Path relative to Home' },
            p = { val = modify(filepath, ':.'), msg = 'Path relative to CWD' },
            P = { val = filepath, msg = 'Absolute path' },
          }

          local messages = {
            { '\nChoose to copy to clipboard:\n', 'Normal' },
          }
          for i, result in pairs(results) do
            if result.val and result.val ~= '' then
              vim.list_extend(messages, {
                { ('%s.'):format(i), 'Identifier' },
                { (' %s: '):format(result.msg) },
                { result.val, 'String' },
                { '\n' },
              })
            end
          end
          vim.api.nvim_echo(messages, false, {})
          local result = results[vim.fn.getcharstr()]
          if result and result.val and result.val ~= '' then
            vim.notify('Copied: ' .. result.val)
            vim.fn.setreg('+', result.val)
          end
        end,
      }
      return {
        popup_border_style = 'NC',
        close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
        nesting_rules = {},
        buffers = {
          follow_current_file = {
            enabled = false,
          },
          commands = global_commands,
        },
        event_handlers = {
          {
            -- Auto close on Open File
            event = 'file_opened',
            handler = function(file_path)
              --auto close
              vim.cmd([[Neotree close]])
            end,
          },
          {
            event = 'neo_tree_buffer_enter',
            handler = function(_)
              vim.opt_local.signcolumn = 'auto'
            end,
          },
        },
        source_selector = {
          winbar = true,
          content_layout = 'center',
          show_scrolled_off_parent_node = true,
          sources = {
            {
              source = 'filesystem',
              display_name = '  Files ',
            },
            {
              source = 'buffers',
              display_name = '  Buffers',
            },
            {
              source = 'git_status',
              display_name = '  Git ',
            },
          },
        },
        default_component_configs = {
          modified = {
            symbol = '',
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
              deleted = '󰧧', -- this can only be used in the git_status source
              renamed = '󰑕', -- this can only be used in the git_status source
              -- Status type
              untracked = '',
              ignored = '',
              unstaged = '',
              staged = '',
              conflict = '',
            },
          },
        },
        window = {
          mappings = {
            ['l'] = 'child_or_open',
            ['h'] = 'parent_or_close',
            ['Y'] = 'copy_selector',
            ['<C-v>'] = 'open_vsplit',
            ['<C-x>'] = 'open_split',
            ['<C-t>'] = 'open_tabnew',
            ['<C-g>'] = 'open_with_window_picker',
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
          hijack_netrw_behavior = 'disabled',
          commands = global_commands,
        },
        diagnostics = { commands = global_commands },
        git_status = {
          commands = global_commands,
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
      }
    end,
    keys = {
      { '<Leader>n', ':Neotree source=filesystem toggle=true<CR>', desc = 'Open Neotree' },
      { '<Leader>N', ':Neotree source=filesystem reveal=true<CR>', desc = 'Open Neotree and find file' },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then
          require('neo-tree')
        end
      end
    end,
  },

  -- Edit filesystem like buffer
  {
    'stevearc/oil.nvim',
    opts = {
      default_file_explorer = true,
      keymaps = {
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = 'actions.select_vsplit',
        ['<C-h>'] = 'actions.select_split',
        ['<C-t>'] = 'actions.select_tab',
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = 'actions.close',
        ['<C-l>'] = 'actions.refresh',
        ['<BS>'] = 'actions.parent',
        ['-'] = 'actions.open_cwd',
        ['`'] = 'actions.cd',
        ['~'] = 'actions.tcd',
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
        ['g\\'] = 'actions.toggle_trash',
      },
    },
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<Leader>o', '<CMD>Oil --float<CR>', desc = 'Open Oil' },
    },
  },

  -- which-key
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
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
      -- defer = { gc = 'Comments' },
      triggers = {
        { '<auto>', mode = 'nxsot' },
        -- { 'j', mode = { 'i', 'v' } },
        -- { 'k', mode = { 'i', 'v' } },
      },
    },
    config = function(_, opts)
      local wk = require('which-key')
      wk.setup(opts)
      wk.add({
        { '<leader>.', group = 'Source/reload' },
        { '<leader>b', group = 'Buffer' },
        { '<leader>d', group = 'Insert' },
        { '<leader>e', group = 'Edit' },
        { '<leader>g', group = 'Gitsigns' },
        { '<leader>m', group = 'Harpoon' },
        { '<leader>s', group = 'Session' },
        { '<leader>x', group = 'tODO/Trouble/FIX' },
        { '<space>d', group = 'Debug' },
        { '<space>r', group = 'Run' },
        { '[', group = 'Prev' },
        { ']', group = 'Next' },
        { 'cr', group = 'Abolish coerce word' },
        { 'g', group = 'Goto' },
        { 'gq', group = 'Quickfix' },
        { 'yo', group = 'Toggle' },
      })
    end,
  },

  -- git signs
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      { 'petertriho/nvim-scrollbar' },
      {
        'echasnovski/mini.diff',
        enabled = false,
        version = false,
        opts = {
          view = {
            style = 'sign',
            signs = { add = '┃', change = '┃', delete = '▒' },
          },
          mappings = {
            goto_first = '',
            goto_prev = '',
            goto_next = '',
            goto_last = '',
          },
        },
        keys = {
          { '<Leader>gd', '<CMD>lua require("mini.diff").toggle_overlay()<CR>', desc = 'Toggle MiniDiff' },
        },
      },
    },
    opts = {
      -- signs = {
      --   add = { text = '┃' },
      --   change = { text = '┃' },
      --   delete = { text = '' },
      --   topdelete = { text = '╈' },
      --   changedelete = { text = '~' },
      --   untracked = { text = '┆' },
      -- },
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
        vim.keymap.set('n', ']g', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, {
          buffer = bufnr,
          expr = true,
          desc = 'Next Hunk',
        })

        vim.keymap.set('n', '[g', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, {
          buffer = bufnr,
          expr = true,
          desc = 'Prev Hunk',
        })

        -- Actions
        map({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk(s)')
        map({ 'n', 'v' }, '<leader>gr', ':Gitsigns reset_hunk<CR>', 'Reset Hunk(s)')
        map('n', '<leader>gS', gs.stage_buffer, 'Stage Buffer')
        map('n', '<leader>gu', gs.undo_stage_hunk, 'Undo Stage Hunk')
        map('n', '<leader>gR', gs.reset_buffer, 'Reset Buffer')
        -- map('n', '<leader>gp', gs.preview_hunk, '')
        -- map('n', '<leader>gb', function()
        --   gs.blame_line({ full = true })
        -- end, 'Blame full')
        -- map('n', '<leader>gd', gs.diffthis, 'Diff')
        -- map('n', '<leader>gD', function() gs.diffthis('~') end, '')

        -- toggles
        map('n', '<leader>gtd', gs.toggle_deleted, 'Toggle Deleted')
        map('n', '<leader>gtw', gs.toggle_word_diff, 'Toggle Word Diff')
        map('n', '<leader>gtl', gs.toggle_linehl, 'Toggle Line Diff HL')
        map('n', '<leader>gtb', gs.toggle_current_line_blame, 'Toggle Current Line Blame')
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
  -- {
  --   'tpope/vim-fugitive',
  --   keys = {
  --     { '<Leader>B', '<CMD>Git blame<CR>', desc = 'Git Blame' },
  --     { '<Leader>G', '<Cmd>tab G<Cr>', desc = 'Open Fugitive Status' },
  --   },
  --   cmd = { 'Git', 'G' },
  --   init = function()
  --     vim.cmd([[command BuCloseFugitive silent call CloseAllTabsWithFiletype('fugitive')]])
  --   end,
  -- },

  -- git blame with stack
  {
    'FabijanZulj/blame.nvim',
    cmd = { 'BlameToggle' },
    opts = {},
    keys = {
      -- { '<Leader>gb', '<CMD>BlameToggle virtual<CR>', desc = 'Blame virtual' },
      { '<Leader>B', '<CMD>BlameToggle window<CR>', desc = 'Blame window' },
    },
  },

  -- diff view
  {
    'sindrets/diffview.nvim',
    opts = function()
      local actions = require('diffview.actions')
      return {
        enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
        keymaps = {
          view = {
            ['q'] = actions.close,
          },
          file_panel = {
            { 'n', '?', actions.help('file_panel'), { desc = 'Open the help panel' } },
            { 'n', 'r', actions.refresh_files, { desc = 'Refresh files' } },
            { 'n', '<Space>', actions.toggle_stage_entry, { desc = 'Stage / unstage the selected entry.' } },
            { 'n', 'e', actions.goto_file, { desc = 'Edit the file in a new split in the previous tabpage' } },
            { 'n', 'q', '<Cmd>DiffviewClose<CR>', { desc = 'Close Diffview' } },
          },
        },
        hooks = {
          diff_buf_read = function(bufnr)
            vim.opt_local.cursorline = false
          end,
        },
      }
    end,
    init = function()
      vim.cmd([[command BuCloseDiffview silent tabdo DiffviewClose]])
    end,
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      {
        '<Leader>D',
        function()
          if next(require('diffview.lib').views) == nil then
            vim.cmd('DiffviewOpen')
          else
            vim.cmd('DiffviewClose')
          end
        end,
        desc = 'Toggle DiffView',
      },
      {
        '<Leader>gc',
        ':DiffviewOpen origin/',
        desc = 'Compare branch:',
      },
      {
        '<Leader>gm',
        '<CMD>DiffviewOpen origin/master<CR>',
        desc = 'Compare with master',
      },
      { '<Leader>gH', '<Cmd>DiffviewFileHistory<Cr>', desc = 'Branch History' },
      { '<Leader>gh', '<Cmd>DiffviewFileHistory %<Cr>', desc = 'Current File History' },
    },
  },

  -- better diagnostics list and others
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble', 'Trouble' },
    opts = { use_diagnostic_signs = true },
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },

  -- todo comments
  {
    'folke/todo-comments.nvim',
    dependencies = { 'numToStr/Comment.nvim' },
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    event = 'BufReadPost',
    opts = {
      keywords = {
        todo = { icon = ' ', color = 'info' },
      },
    },
    config = function(_, opts)
      -- Add lowercase versions of each keyword
      for key, val in pairs(opts.keywords) do
        opts.keywords[key:lower()] = val
      end
      require('todo-comments').setup(opts)
    end,
    -- stylua: ignore
    keys = {
      { "]x", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[x", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>xT", 'gcOTODO: ', desc = "Open TODO above", remap = true },
      { "<leader>xt", 'gcoTODO: ', desc = "Open TODO below", remap = true },
      { "<leader>xF", 'gcOFIXME: ', desc = "Open FIXME above", remap = true },
      { "<leader>xf", 'gcoFIXME: ', desc = "Open FIXME below", remap = true },
    },
  },

  -- harpoon
  {
    'ThePrimeagen/harpoon',
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
    },
    keys = {
      {
        '<Leader>ma',
        function()
          require('harpoon.mark').add_file()
          local filename = vim.api.nvim_buf_get_name(0)
          print('Harpoon Add: ' .. filename)
        end,
      },
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

  {
    'carbon-steel/detour.nvim',
    config = function()
      vim.keymap.set('n', '<Space>D', ':Detour<cr>')
    end,
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
        stogglebuf = 'gqt', -- toggle signs for same buffers under the cursor
        sclear = 'gqT', -- clear the signs in current quickfix list
        fzffilter = '/',
        filter = 'f', -- create new list for signed items
        filterr = 'F', -- create new list for non-signed items
      },
      filter = {
        fzf = {
          action_for = {
            ['enter'] = 'signtoggle',
          },
          extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ' },
        },
      },
    },
  },

  -- make quickfix editable
  { 'itchyny/vim-qfedit' },

  -- better visuals for diagnostics
  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    opts = {},
    keys = {
      {
        'yod',
        function()
          require('lsp_lines').toggle()
        end,
        desc = 'Toggle lsp_lines',
      },
    },
  },

  -- pretty code snapshots
  {
    'mistricky/codesnap.nvim',
    cmd = { 'CodeSnap', 'CodeSnapSave' },
    build = 'make',
    opts = {
      has_breadcrumbs = true,
      watermark = '',
      mac_window_bar = false,
      save_path = '~/',
    },
  },

  -- auto-resizing splits
  {
    'nvim-focus/focus.nvim',
    version = false,
    cmd = { 'FocusToggle' },
    opts = {},
    keys = {
      { 'yof', '<Cmd>FocusToggle<CR>', desc = 'Toggle Focus' },
      -- { '<Leader>=', '<Cmd>FocusSplitNicely<CR>', desc = 'Split window nicely' },
    },
  },
}
