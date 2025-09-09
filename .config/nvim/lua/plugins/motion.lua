return {
  -- easily jump to any location and enhanced f/t motions for Leap
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          autohide = true,
          jump_labels = true,
          ---@alias Flash.CharActions table<string, "next" | "prev" | "right" | "left">
          keys = { 'f', 'F', 't', 'T', ';' },
          label = { exclude = 'hjkliardcebwpDPWBEgx' },
          char_actions = function(motion)
            return {
              --[[ [";"] = "next", -- set to `right` to always go right ]]
              --[[ [","] = "prev", -- set to `left` to always go left ]]
              -- clever-f style
              [motion:lower()] = 'next',
              [motion:upper()] = 'prev',
            }
          end,
          -- dynamic configuration for ftFT motions
          config = function(opts)
            -- autohide flash when in operator-pending mode
            -- opts.autohide = (vim.fn.mode(true):find('no') and vim.v.operator == 'y')

            -- Show jump labels when not in operator-pending mode, not recording, and not executing
            opts.jump_labels = vim.v.count == 0
              and not vim.fn.mode(true):find('o')
              and vim.fn.reg_executing() == ''
              and vim.fn.reg_recording() == ''
          end,
          highlight = {
            backdrop = false,
            matches = false,
          },
        },
        search = {
          enabled = false, -- enable flash for search
          highlight = { backdrop = false },
          jump = { history = true, register = true, nohlsearch = true },
          search = {
            -- `forward` will be automatically set to the search direction
            -- `mode` is always set to `search`
            -- `incremental` is set to `true` when `incsearch` is enabled
          },
        },
      },
    },
    keys = {
      {
        's',
        mode = { 'n', 'x' },
        function()
          -- default options: exact mode, multi window, all directions, with a backdrop
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'o' },
        function()
          -- show labeled treesitter nodes around the cursor
          require('flash').jump()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'S',
        mode = { 'n' },
        function()
          -- show labeled treesitter nodes around the cursor
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'm',
        mode = 'o',
        function()
          -- jump to a remote location to execute the operator
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      -- {
      --   'gt',
      --   mode = { 'n', 'o', 'x' },
      --   function()
      --     -- show labeled treesitter nodes around the search matches
      --     require('flash').treesitter_search()
      --   end,
      --   desc = 'Treesitter Search',
      -- },
    },
  },

  {
    'bloznelis/before.nvim',
    dependencies = { 'telescope.nvim' },
    config = function()
      local before = require('before')
      before.setup()

      -- Jump to previous entry in the edit history
      vim.keymap.set('n', '[e', before.jump_to_last_edit, { desc = 'Previous Edit' })

      -- Jump to next entry in the edit history
      vim.keymap.set('n', ']e', before.jump_to_next_edit, { desc = 'Next Edit' })

      -- Look for previous edits in telescope (needs telescope, obviously)
      vim.keymap.set('n', '<Space>te', before.show_edits_in_telescope, { desc = 'Edits' })
    end,
  },

  -- Preview jumplist
  {
    'suliatis/Jumppack.nvim',
    opts = {
      options = {
        global_mappings = false,
        wrap_edges = false,
      },
    },
    keys = {
      {
        '<C-A-o>',
        function()
          require('Jumppack').start({ offset = -1 })
        end,
        mode = { 'n' },
      },
      {
        '<C-A-i>',
        function()
          require('Jumppack').start({ offset = 1 })
        end,
        mode = { 'n' },
      },
    },
  },

  {
    'haya14busa/vim-asterisk',
    keys = {
      -- { '*', '<Plug>(asterisk-*)', mode = { 'n', 'x' } },
      -- { '#', '<Plug>(asterisk-#)', mode = { 'n', 'x' } },
      -- { 'g*', '<Plug>(asterisk-g*)', mode = { 'n', 'x' } },
      -- { 'g#', '<Plug>(asterisk-g#)', mode = { 'n', 'x' } },
      -- { 'z*', '<Plug>(asterisk-z*)', mode = { 'n', 'x' } },
      -- { 'gz*', '<Plug>(asterisk-gz*)', mode = { 'n', 'x' } },
      -- { 'z#', '<Plug>(asterisk-z#)', mode = { 'n', 'x' } },
      -- { 'gz#', '<Plug>(asterisk-gz#)', mode = { 'n', 'x' } },
      -- { 'gz#', '<Plug>(asterisk-gz#)', mode = { 'n', 'x' } },
    },
    init = function()
      vim.g['asterisk#keeppos'] = 1
    end,
  },

  {
    'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup({
        handlers = {
          diagnostic = false,
          gitsigns = true, -- Requires gitsigns
          search = true, -- Requires hlslens
        },
      })
    end,
  },

  {
    'kevinhwang91/nvim-hlslens',
    dependencies = {
      'haya14busa/vim-asterisk',
      'petertriho/nvim-scrollbar',
    },
    config = function(_, opts)
      require('hlslens').setup({
        build_position_cb = function(plist, _, _, _)
          require('scrollbar.handlers.search').handler.show(plist.start_pos)
        end,
      })
      vim.cmd([[
        augroup scrollbar_search_hide
            autocmd!
            autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
        augroup END
    ]])
    end,
    keys = {
      { 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { '*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], mode = { 'n', 'x' } },
      { '#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], mode = { 'n', 'x' } },
      { 'g*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], mode = { 'n', 'x' } },
      { 'g#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], mode = { 'n', 'x' } },
    },
  },

  {
    'chentoast/marks.nvim',
    opts = {
      mappings = {
        next = ']m',
        prev = '[m',
        toggle = 'mm',
        delete_line = 'dm',
        delete_buf = 'dM',
      },
      default_mappings = true,
      -- which builtin marks to show. default {}
      builtin_marks = {},
      -- whether movements cycle back to the beginning/end of buffer. default true
      cyclic = true,
      -- whether the shada file is updated after modifying uppercase marks. default false
      force_write_shada = false,
      -- how often (in ms) to redraw signs/recompute mark positions.
      -- higher values will have better performance but may cause visual lag,
      -- while lower values may cause performance penalties. default 150.
      refresh_interval = 250,
      -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
      -- marks, and bookmarks.
      -- can be either a table with all/none of the keys, or a single number, in which case
      -- the priority applies to all marks.
      -- default 10.
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      -- disables mark tracking for specific filetypes. default {}
      excluded_filetypes = {},
      -- disables mark tracking for specific buftypes. default {}
      excluded_buftypes = {},
      -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
      -- sign/virttext. Bookmarks can be used to group together positions and quickly move
      -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
      -- default virt_text is "".
      -- bookmark_0 = {
      --   sign = '⚑',
      --   virt_text = 'hello world',
      --   -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
      --   -- defaults to false.
      --   annotate = false,
      -- },
    },
  },
}
