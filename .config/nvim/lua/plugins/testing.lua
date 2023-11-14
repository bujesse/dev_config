return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-plenary',
      'nvim-neotest/neotest-python',
    },
    lazy = false,
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-plenary'),
          require('neotest-python')({
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            dap = {
              justMyCode = false,
              -- Hide extra variable info don't need
              variablePresentation = {
                ['function'] = 'hide',
                special = 'hide',
              },
            },
            -- args = { '--log-level', 'DEBUG' },
            runner = 'pytest',
            -- python = 'venv/bin/python',
            -- Returns if a given file path is a test file.
            -- is_test_file = function(file_path) end,
          }),
        },
        icons = {
          failed = '',
          passed = '',
          running = '',
          running_animated = { '/', '|', '\\', '-', '/', '|', '\\', '-' },
          skipped = '鈴',
          unknown = '',
        },
        quickfix = {
          enabled = false,
          open = false,
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = false,
        },
      })
      -- TODO: open diagnostics for just test bufferse
      -- TODO: setup autocommand for keymaps
      -- local augroup = vim.api.nvim_create_augroup('TestFiles', { clear = false })
      -- vim.api.nvim_create_autocmd('Buf', {
      --   pattern = '*_spec.lua',
      --   group = augroup,
      --   callback = function()
      --   end,
      -- })
      -- M.formatting_on = true
    end,
    keys = {
      -- TODO: { '<Space>ra', 'require("neotest").run.run()', desc = 'Run All Tests' },
      { '<Space>rr', '<Plug>PlenaryTestFile', desc = 'Plenary test' },

      { '<Space>rn', '<Cmd>lua require("neotest").run.run()<Cr>', desc = 'Run Nearest Test' },
      { '<Space>rl', '<Cmd>lua require("neotest").run.run_last()<Cr>', desc = 'Run Last Test' },
      -- { '<Space>rf', '<Cmd>lua require("neotest").run.run(vim.fn.expand("%"))<Cr>', desc = 'Run File' },
      { '<Space>rf', '<Plug>PlenaryTestFile', desc = 'Run File' },
      { '<Space>rS', '<Cmd>lua require("neotest").run.stop()<Cr>', desc = 'Stop Nearest Test' },
      { '<Space>ro', '<Cmd>lua require("neotest").output_panel.open({ enter = true })<cr>', desc = 'Test Output' },
      { '<Space>rs', '<Cmd>lua require("neotest").summary.open()<cr>', desc = 'Open Test Summary View' },
      {
        '<Space>dn',
        '<Cmd>lua require("neotest").run.run({strategy = "dap"})<Cr>',
        desc = 'Debug Nearest Test (neotest)',
      },
      {
        '<Space>df',
        '<Cmd>lua require("neotest").run.run({vim.fn.expand("%"), strategy = "dap"})<Cr>',
        desc = 'Debug File, (neotest)',
      },
      {
        '<Space>dl',
        '<Cmd>lua require("neotest").run.run_last({strategy = "dap"})<Cr>',
        desc = 'Debug Last Test (neotest)',
      },
      { '[n', '<cmd>lua require("neotest").jump.prev({ status = "failed" })<CR>', desc = 'Next failing test' },
      { ']n', '<cmd>lua require("neotest").jump.next({ status = "failed" })<CR>', desc = 'Next failing test' },
    },
  },
  {
    'rafcamlet/nvim-luapad',
    opts = {},
    config = function(_, opts)
      require('luapad').setup(opts)
      vim.api.nvim_create_user_command('LuapadNew', "lua require('luapad').init()", {})
      vim.api.nvim_create_user_command('LuapadDetach', "lua require('luapad').detach()", {})
      vim.api.nvim_create_user_command('LuapadToggle', "lua require('luapad').toggle()", {})
    end,
  },
}
