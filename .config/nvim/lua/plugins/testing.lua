return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-plenary',
  },
  lazy = false,
  config = function()
    require('neotest').setup({
      adapters = {
        require('neotest-plenary'),
      },
    })
  end,
  keys = {
    -- TODO: { '<Space>ra', 'require("neotest").run.run()', desc = 'Run All Tests' },
    { '<Space>rn', '<Cmd>lua require("neotest").run.run()<Cr>', desc = 'Run Nearest Test' },
    { '<Space>rl', '<Cmd>lua require("neotest").run.run_last()<Cr>', desc = 'Run Last Test' },
    { '<Space>rf', '<Cmd>lua require("neotest").run.run(vim.fn.expand("%"))<Cr>', desc = 'Run File' },
    { '<Space>rs', '<Cmd>lua require("neotest").run.stop()<Cr>', desc = 'Stop Nearest Test' },
    { '<Space>ro', '<Cmd>lua require("neotest").output.open({ enter = true })<cr><Cr>', desc = 'Test Output' },
    { '<Space>dn', '<Cmd>lua require("neotest").run.run({strategy = "dap"})<Cr>', desc = 'Debug Nearest Test' },
    { '<Space>dl', '<Cmd>lua require("neotest").run.run_last({strategy = "dap"})<Cr>', desc = 'Debug Last Test' },
  },
}
