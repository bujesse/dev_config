local M = {}

function M.config()
  require('aerial').setup({
    -- optionally use on_attach to set keymaps when aerial has attached to a buffer
    layout = {
      default_direction = "prefer_left",
      placement = 'window',
    },
    attach_mode = 'window',
    show_guides = true,
    on_attach = function(bufnr)
      vim.keymap.set('n', ']s', 'm\'<cmd>AerialNext<CR>', { desc = 'Next [S]ymbol (Aerial)', buffer = bufnr })
      vim.keymap.set('n', '[s', 'm\'<cmd>AerialPrev<CR>', { desc = 'Prev [S]ymbol (Aerial)', buffer = bufnr })
    end
  })

  vim.keymap.set('n', '<Leader>a', '<cmd>AerialToggle!<CR>')
  vim.keymap.set('n', '<Space>ta', ':lua require("telescope").extensions.aerial.aerial()<CR>',
    { desc = 'Aerial Symbols' })
end

return M
