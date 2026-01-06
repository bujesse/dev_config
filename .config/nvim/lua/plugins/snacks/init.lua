return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      animate = {
        ---@type snacks.animate.Duration|number
        duration = 10, -- ms per step
        easing = 'inOutSine',
        fps = 60, -- frames per second. Global setting for all animations
      },
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      indent = {
        enabled = true,
        animate = {
          enabled = vim.fn.has('nvim-0.10') == 1,
          style = 'out',
          easing = 'linear',
          duration = {
            step = 10, -- ms per step
            total = 150, -- maximum duration
          },
        },
      },
      input = { enabled = true },
      notifier = {
        enabled = false,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 10, total = 115 },
          easing = 'inOutSine',
          spamming = 10, -- threshold for spamming detection
        },
      },
      statuscolumn = { enabled = true },
      words = {
        enabled = true,
        notify_jump = true,
      },
      styles = {},
      explorer = {
        replace_netrw = true,
      },
      picker = {
        formatters = {
          -- For fff.lua picker
          file = {
            filename_first = true,
            truncate = 40,
            filename_only = false,
            icon_width = 2,
            git_status_hl = true,
          },
        },
        actions = {
          find_in_dir = function(picker)
            local target_dir = picker:dir()
            print('Find in dir:', target_dir)
            Snacks.picker.grep({
              regex = false,
              dirs = { target_dir },
            })
          end,
          flash = function(picker)
            require('flash').jump({
              pattern = '^',
              label = { after = { 0, 0 } },
              search = {
                mode = 'search',
                exclude = {
                  function(win)
                    return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'snacks_picker_list'
                  end,
                },
              },
              action = function(match)
                local idx = picker.list:row2idx(match.pos[1])
                picker.list:_move(idx, true, true)
              end,
            })
          end,
        },
        win = {
          -- input window
          input = {
            keys = {
              -- close the picker on ESC instead of going to normal mode,
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
              ['<C-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
              ['<C-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
              ['<C-Up>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
              ['<C-Down>'] = { 'list_scroll_down', mode = { 'i', 'n' } },
              ['<C-_>'] = { 'toggle_focus', mode = { 'i', 'n' } },
              ['<C-p>'] = { 'history_back', mode = { 'i', 'n' } },
              ['<C-n>'] = { 'history_forward', mode = { 'i', 'n' } },
              ['<m-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
              ['<m-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
              ['<C-m>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
              ['<C-f>'] = { 'toggle_live', mode = { 'i', 'n' } },
              ['<C-g>'] = { { 'pick_win', 'edit' }, mode = { 'i', 'n' } },
              ['<a-s>'] = { 'flash', mode = { 'n', 'i' } },
              ['s'] = { 'flash' },
            },
          },
          list = {
            keys = {
              ['<c-q>'] = { 'qflist', mode = { 'i', 'n' } },
              ['<C-g>'] = { { 'pick_win', 'edit' }, mode = { 'i', 'n' } },
              ['<Space>f'] = { 'find_in_dir', mode = { 'n' } },
              ['<C-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
              ['<C-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
              ['<C-Up>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
              ['<C-Down>'] = { 'list_scroll_down', mode = { 'i', 'n' } },
            },
          },
        },
      },
    },
    keys = {
      {
        '<Space>o',
        function()
          -- require('plugins.snacks.fff').fff()
          require('fff').find_files() -- Find files in current directory
        end,
        desc = 'Smart Find Files',
      },
      {
        '<Space>O',
        function()
          Snacks.picker.files({ hidden = true, ignored = true })
        end,
        desc = 'Find All Files',
      },
      {
        '<Space>m',
        function()
          Snacks.picker.recent()
        end,
        desc = 'Recent Files',
      },
      {
        '<Space>tm',
        function()
          Snacks.picker.marks()
        end,
        desc = 'Marks',
      },
      {
        '<Space>f',
        function()
          Snacks.picker.grep({ regex = false })
        end,
        desc = 'Fuzzy Grep',
      },
      {
        '<Space>F',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep Regex',
      },
      {
        '<Space>h',
        function()
          Snacks.picker.help()
        end,
        desc = 'Help',
      },
      {
        "<Space>'",
        function()
          Snacks.picker.resume()
        end,
        desc = 'Resume',
      },
      {
        '<Space>g',
        function()
          Snacks.picker.git_status()
        end,
        desc = 'Git Status',
      },
      {
        '<Space>tl',
        function()
          Snacks.picker.git_log()
        end,
        desc = 'Git Log',
      },
      {
        '<Space>G',
        function()
          Snacks.picker.git_diff()
        end,
        desc = 'Git Diff (Hunks)',
      },
      {
        '<Space>u',
        function()
          Snacks.picker.undo()
        end,
        desc = 'Undo History',
      },
      {
        '<Space>/',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Buffer Lines',
      },
      {
        '<Space><Space>',
        function()
          Snacks.picker.buffers({
            win = {
              input = {
                keys = {
                  ['d'] = 'bufdelete',
                },
              },
              list = {
                keys = {
                  ['d'] = 'bufdelete',
                },
              },
            },
          })
        end,
        desc = 'Buffers',
      },
      {
        '<Space>tB',
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = 'Grep Open Buffers',
      },
      {
        '<Space>tu',
        function()
          Snacks.picker.grep_word()
        end,
        desc = 'Word under cursor',
        mode = { 'n', 'x' },
      },
      {
        '<Space>f',
        function()
          Snacks.picker.grep_word()
        end,
        desc = 'Visual selection',
        mode = { 'x' },
      },
      {
        '<Space>ti',
        function()
          Snacks.picker.icons()
        end,
        desc = 'Icons',
      },
      {
        '<Space>j',
        function()
          Snacks.picker.jumps()
        end,
        desc = 'Jumps',
      },
      {
        '<Space>p',
        function()
          Snacks.picker.pickers()
        end,
        desc = 'Pickers',
      },
      {
        '<Space>tk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = 'Keymaps',
      },
      {
        '<Space>ts',
        function()
          Snacks.picker.lsp_symbols({
            focus = 'list',
            layout = {
              preset = 'right',
              preview = 'main',
            },
          })
        end,
        desc = 'Snacks Symbols',
      },
      {
        'gr',
        function()
          Snacks.picker.lsp_references({
            focus = 'list',
            layout = { preset = 'ivy' },
          })
        end,
        desc = 'LSP References',
      },
      {
        'gi',
        function()
          Snacks.picker.lsp_incoming_calls({
            focus = 'list',
            layout = { preset = 'ivy' },
          })
        end,
        desc = 'LSP References',
      },
      {
        'go',
        function()
          Snacks.picker.lsp_outgoing_calls({
            focus = 'list',
            layout = { preset = 'ivy' },
          })
        end,
        desc = 'LSP References',
      },
      {
        'gd',
        function()
          Snacks.picker.lsp_definitions({
            focus = 'list',
            layout = { preset = 'ivy' },
          })
        end,
        desc = 'LSP definitions',
      },
      {
        'gm',
        function()
          Snacks.picker.lsp_implementations({
            focus = 'list',
            layout = { preset = 'ivy' },
          })
        end,
        desc = 'LSP Implementations',
      },
      {
        'gy',
        function()
          Snacks.picker.lsp_type_definitions({
            focus = 'list',
            layout = { preset = 'ivy' },
          })
        end,
        desc = 'LSP Type Definitions',
      },
      {
        '<Space>S',
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = 'Keymaps',
      },
      {
        '<Space>;',
        function()
          Snacks.picker.commands()
        end,
        desc = 'Commands',
      },
      {
        '<leader>n',
        function()
          Snacks.picker.explorer({
            auto_close = false,
            win = {
              input = {
                keys = {
                  ['.'] = 'tcd',
                },
              },
              list = {
                keys = {
                  ['.'] = 'tcd',
                },
              },
            },
          })
        end,
        desc = 'Toggle Explorer',
      },
      {
        '<leader>N',
        function()
          Snacks.explorer.reveal({
            hidden = true,
            ignored = true,
            auto_close = false,
          })
        end,
        desc = 'Reveal current file',
      },
      {
        '<leader>z',
        function()
          Snacks.zen()
        end,
        desc = 'Toggle Zen Mode',
      },
      {
        '<leader>Z',
        function()
          Snacks.zen.zoom()
        end,
        desc = 'Toggle Zoom',
      },
      {
        '<leader><Space>',
        function()
          Snacks.scratch()
        end,
        desc = 'Toggle Scratch Buffer',
      },
      {
        '<leader>S',
        function()
          Snacks.scratch.select()
        end,
        desc = 'Select Scratch Buffer',
      },
      {
        '[s',
        function()
          Snacks.scope.jump()
        end,
        desc = 'Top of scope',
        mode = { 'n', 'x', 'o' },
      },
      {
        ']s',
        function()
          Snacks.scope.jump({ bottom = true })
        end,
        desc = 'Bottom of scope',
        mode = { 'n', 'x', 'o' },
      },
      {
        'is',
        function()
          Snacks.scope.textobject({ edge = false })
        end,
        desc = 'Inner scope',
        mode = { 'x', 'o' },
      },
      {
        'as',
        function()
          Snacks.scope.textobject()
        end,
        desc = 'Around scope',
        mode = { 'x', 'o' },
      },
      {
        '<leader>gB',
        function()
          Snacks.gitbrowse()
        end,
        desc = 'Git Browse (open in browser)',
        mode = { 'n', 'v' },
      },
      {
        '<leader>gb',
        function()
          Snacks.git.blame_line()
        end,
        desc = 'Git Blame',
      },
      {
        '<leader>L',
        function()
          Snacks.lazygit.log_file()
        end,
        desc = 'Lazygit Current File History',
      },
      {
        '<leader>l',
        function()
          Snacks.lazygit()
        end,
        desc = 'Lazygit',
      },
      {
        '<leader>gl',
        function()
          Snacks.lazygit.log()
        end,
        desc = 'Lazygit Log (cwd)',
      },
      {
        ']r',
        function()
          Snacks.words.jump(1, true)
        end,
        desc = 'Next Reference',
      },
      {
        '[r',
        function()
          Snacks.words.jump(-1, true)
        end,
        desc = 'Prev Reference',
      },
      {
        '<C-f>',
        function()
          function _G.set_terminal_keymaps()
            local opts = { buffer = 0 }
            -- vim.keymap.set('t', [[<C-x>]], [[<C-\><C-n>]], opts)
            vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
            vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
            vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
            vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
            vim.keymap.set('t', '<C-q>', [[<Cmd>wincmd q<CR>]], opts)
            vim.keymap.set('t', '<C-f>', [[<Cmd>wincmd q<CR>]], opts)
          end
          vim.cmd('autocmd! FileType snacks_terminal lua set_terminal_keymaps()')
          -- Snacks.terminal.toggle('btm')
          Snacks.terminal.toggle()
        end,
        desc = 'Toggle Term',
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          -- Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map('yow')
          -- Snacks.toggle.diagnostics():map('<leader>ud')
          -- Snacks.toggle.line_number():map('<leader>ul')
          -- Snacks.toggle
          --   .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          --   :map('<leader>uc')
          -- Snacks.toggle.treesitter():map('yot')
          -- Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
          Snacks.toggle.inlay_hints():map('yoh')
          Snacks.toggle.indent():map('yoi')
          Snacks.toggle.dim():map('yoD')
        end,
      })
    end,
  },
}
