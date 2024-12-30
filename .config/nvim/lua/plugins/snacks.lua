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
      words = { enabled = false },
      styles = {},
    },
    keys = {
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
        '<leader>.',
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
        '<leader>gR',
        function()
          Snacks.rename.rename_file()
        end,
        desc = 'Rename File',
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
        '<leader>gf',
        function()
          Snacks.lazygit.log_file()
        end,
        desc = 'Lazygit Current File History',
      },
      {
        '<leader>gg',
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

          vim.keymap.del('n', 'nil')
        end,
      })
    end,
  },
}
