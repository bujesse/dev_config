return {
  -- DAP
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    dependencies = {
      {
        'mfussenegger/nvim-dap-python',
        config = function()
          require('dap-python').setup(vim.g.python3_host_prog)
          require('dap-python').test_runner = 'pytest'
        end,
      },
      {
        'ofirgall/goto-breakpoints.nvim',
        keys = {
          {
            ']b',
            function()
              require('goto-breakpoints').next()
            end,
            desc = 'Next Breakpoint',
          },
          {
            '[b',
            function()
              require('goto-breakpoints').prev()
            end,
            desc = 'Prev Breakpoint',
          },
        },
      },
    },
    keys = {
      { '<Space>b', "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = 'Toggle Breakpoint' },
      {
        '<Space>B',
        "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
        desc = 'Toggle Breakpoint',
      },
      {
        '<Space>dL',
        "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
        desc = 'Toggle Breakpoint',
      },

      { '<F5>', "<cmd>lua require'dap'.step_over()<cr>", desc = 'Step Over' },
      { '<F4>', "<cmd>lua require'dap'.step_into()<cr>", desc = 'Step Into' },
      { '<F3>', "<cmd>lua require'dap'.step_out()<cr>", desc = 'Step Out' },
      { '<F2>', "<cmd>lua require'dap'.run_to_cursor()<cr>", desc = 'Run To Cursor' },
      { '<F1>', "<cmd>lua require'dap'.continue()<cr>", desc = 'Continue' },

      { '<Space>db', "<cmd>lua require'dap'.step_back()<cr>", desc = 'Step Back' },
      { '<Space>dd', "<cmd>lua require'dap'.disconnect()<cr>", desc = 'Disconnect' },
      { '<Space>dg', "<cmd>lua require'dap'.session()<cr>", desc = 'Get Session' },
      { '<Space>dp', "<cmd>lua require'dap'.pause()<cr>", desc = 'Pause' },
      { '<Space>dr', "<cmd>lua require'dap'.repl.toggle()<cr>", desc = 'Toggle Repl' },
      { '<Space>dq', "<cmd>lua require'dap'.close()<cr>", desc = 'Quit' },
      { '<Space>du', "<cmd>lua require'dapui'.toggle({reset = true})<cr>", desc = 'Toggle UI' },
    },
    config = function(_, opts)
      vim.fn.sign_define('DapBreakpoint', {
        text = '🔴',
        texthl = 'DiagnosticSignError',
        linehl = '',
        numhl = '',
      })
      -- vim.fn.sign_define('DapBreakpointRejected', lvim.builtin.dap.breakpoint_rejected)
      vim.fn.sign_define('DapStopped', {
        text = '👉',
        texthl = 'DiagnosticSignWarn',
        linehl = 'Visual',
        numhl = 'DiagnosticSignWarn',
      })
    end,
  },

  {
    'rcarriga/nvim-dap-ui',
    event = 'VeryLazy',
    opts = {
      controls = {
        element = 'repl',
        enabled = true,
        icons = {
          disconnect = '',
          pause = '',
          play = '',
          run_last = '',
          step_back = '',
          step_into = '<F4>',
          step_out = '<F3>',
          step_over = '<F5>',
          terminate = '<Space>',
        },
      },
      element_mappings = {},
      expand_lines = true,
      floating = {
        border = 'single',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      force_buffers = true,
      icons = {
        collapsed = '+',
        current_frame = '>',
        expanded = '-',
      },
      layouts = {
        {
          elements = {
            {
              id = 'scopes',
              size = 0.35,
            },
            {
              id = 'watches',
              size = 0.35,
            },
            {
              id = 'breakpoints',
              size = 0.15,
            },
            {
              id = 'stacks',
              size = 0.15,
            },
          },
          position = 'left',
          size = 40,
        },
        {
          elements = {
            {
              id = 'repl',
              size = 0.5,
            },
            {
              id = 'console',
              size = 0.5,
            },
          },
          position = 'bottom',
          size = 10,
        },
      },
      mappings = {
        edit = 'e',
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        repl = 'r',
        toggle = 't',
      },
      render = {
        indent = 1,
        max_value_lines = 100,
      },
    },
    config = function(_, opts)
      local dap, dapui = require('dap'), require('dapui')
      dapui.setup(opts)
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      vim.keymap.set('n', '<Space>de', ':lua require("dapui").eval()<CR>', { desc = 'DapUI Eval' })
      vim.keymap.set('n', '<Space>da', ':lua require("dapui").elements.watches.add()<CR>', { desc = 'Add to watches' })
      vim.keymap.set('x', '<Space>da', function()
        local visual_selection = require('core.utils').selected_text()
        require('dapui').elements.watches.add(visual_selection)
      end, { desc = 'Add to watches' })
    end,
  },

  -- easy print statement insertions
  {
    'andrewferrier/debugprint.nvim',
    opts = {
      create_keymaps = false,
      move_to_debugline = true,
    },
    keys = {
      {
        '<Leader>dd',
        function()
          return require('debugprint').debugprint()
        end,
        expr = true,
        desc = 'Debug print string',
      },
      {
        '<Leader>dv',
        function()
          return require('debugprint').debugprint({ variable = true })
        end,
        expr = true,
        mode = { 'n', 'x' },
        desc = 'Debug print variable',
      },
      {
        '<Leader>do',
        function()
          return require('debugprint').debugprint({ motion = true })
        end,
        expr = true,
        desc = 'Debug print motion',
      },
      {
        '<Leader>d-',
        ':DeleteDebugPrints<CR>',
        desc = 'Delete debug prints',
      },
    },
  },
}
