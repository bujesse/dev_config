local function accept_word()
  vim.fn['copilot#Accept']('')
  local bar = vim.fn['copilot#TextQueuedForInsertion']()
  return vim.fn.split(bar, [[[ .]\zs]])[1]
end

local function accept_line()
  vim.fn['copilot#Accept']('')
  local bar = vim.fn['copilot#TextQueuedForInsertion']()
  return vim.fn.split(bar, [[[\n]\zs]])[1]
end

return {
  -- AI
  {
    'github/copilot.vim',
    enabled = false,
    lazy = false,
    config = function()
      vim.g.copilot_no_tab_map = true
    end,
    keys = {
      { 'yoC', '<CMD>Copilot enable<CR>', desc = 'Enable Copilot' },
      { '<M-n>', '<Plug>(copilot-next)', mode = { 'i' } },
      { '<M-p>', '<Plug>(copilot-previous)', mode = { 'i' } },
      { '<C-Right>', accept_word, mode = { 'i' }, remap = false, expr = true },
      { '<C-l>', accept_line, mode = { 'i' }, remap = false, expr = true },
      { '<Right>', 'copilot#Accept("<CR>")', mode = { 'i' }, silent = true, expr = true },
    },
  },

  -- Lua Copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    keys = {
      { 'yoc', 'require("copilot.suggestion").toggle_auto_trigger()', desc = 'Toggle Copilot Auto-trigger' },
    },
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = '<Right>',
          accept_word = '<C-Right>',
          accept_line = '<C-l>',
          next = '<M-n>',
          prev = '<M-p>',
          dismiss = '<M-e>',
        },
      },
    },
  },

  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    keys = {
      { '<Space>cc', '<CMD>CopilotChatToggle<CR>', desc = 'Toggle Copilot Chat', mode = { 'n', 'v' } },
      { '<Space>C', '<CMD>CopilotChatReset<CR>', desc = 'Toggle Copilot Chat', mode = { 'n', 'v' } },
      { '<Space>ce', '<CMD>CopilotChatExplain<CR>', desc = 'Explain', mode = { 'n', 'v' } },
      { '<Space>ct', '<CMD>CopilotChatTests<CR>', desc = 'Tests', mode = { 'n', 'v' } },
      { '<Space>cf', '<CMD>CopilotChatFix<CR>', desc = 'Fix', mode = { 'n', 'v' } },
      { '<Space>cr', '<CMD>CopilotChatOptimize<CR>', desc = 'Optimize', mode = { 'n', 'v' } },
      { '<Space>cd', '<CMD>CopilotChatDocs<CR>', desc = 'Docs', mode = { 'n', 'v' } },
      { '<Space>cF', '<CMD>CopilotChatFixDiagnostic<CR>', desc = 'Fix Diagnostic', mode = { 'n', 'v' } },
      { '<Space>cm', '<CMD>CopilotChatCommitStaged<CR>', desc = 'Commit message for staged', mode = { 'n', 'v' } },
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
