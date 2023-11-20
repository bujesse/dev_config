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
      { 'yoc', '<CMD>Copilot enable<CR>', desc = 'Enable Copilot' },
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
}
