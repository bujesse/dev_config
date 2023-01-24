local M = {}

function M.config()
  local dap = require('dap')

  vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
  dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

  require('which-key').register({
    name = '+debug',
    b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", 'Toggle Breakpoint' },
    -- b = { "<cmd>lua require'dap'.step_back()<cr>", 'Step Back' },
    c = { "<cmd>lua require'dap'.continue()<cr>", 'Continue' },
    j = { "<cmd>lua require'dap'.run_to_cursor()<cr>", 'Run To Cursor' },
    d = { "<cmd>lua require'dap'.disconnect()<cr>", 'Disconnect' },
    g = { "<cmd>lua require'dap'.session()<cr>", 'Get Session' },
    i = { "<cmd>lua require'dap'.step_into()<cr>", 'Step Into' },
    n = { "<cmd>lua require'dap'.step_over()<cr>", 'Step Over' },
    o = { "<cmd>lua require'dap'.step_out()<cr>", 'Step Out' },
    p = { "<cmd>lua require'dap'.pause.toggle()<cr>", 'Pause' },
    r = { "<cmd>lua require'dap'.repl.toggle()<cr>", 'Toggle Repl' },
    q = { "<cmd>lua require'dap'.close()<cr>", 'Quit' },
  }, {
    prefix = '<Space>',
  })
end

-- TODO put this up there ^^^ call in ftplugin

-- M.dap = function()
--   if lvim.plugin.dap.active then
--     local dap_install = require "dap-install"
--     dap_install.config("python_dbg", {})
--   end
-- end
--
-- M.dap = function()
--   -- gem install readapt ruby-debug-ide
--   if lvim.plugin.dap.active then
--     local dap_install = require "dap-install"
--     dap_install.config("ruby_vsc_dbg", {})
--   end
-- end

return M
