-- Local plugins

return {
  {
    'bujesse/what-key.nvim',
    -- dev = true,
    cmd = { 'WhatKeyToggle', 'WhatKeyShow' },
    keys = {
      { '<Space>w', "<Cmd>lua require('what-key.view').toggle()<Cr>", desc = 'WhatKeyToggle' },
    },
    config = function()
      -- vim.keymap.set('n', '<M-a>', ':echo hello<cr>')
      require('what-key').setup({
        -- default_keyboard_layout = 'uk',
        -- use_global_key_preset = 'uk_global_keys',
      })
    end,
  },
}
