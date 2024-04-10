return {
  -- easily jump to any location and enhanced f/t motions for Leap
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          enabled = false,
          autohide = true,
          jump_labels = true,
          multi_line = true,
          -- by default all keymaps are enabled, but you can disable some of them,
          -- by removing them from the list.
          keys = { 'f', 'F', 't', 'T', ';' },
          highlight = { backdrop = false },
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
}
