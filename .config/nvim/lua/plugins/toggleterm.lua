local M = {}

function M.config()
  require('toggleterm').setup({
    shell = '/usr/local/bin/fish',
    open_mapping = [[<c-\>]],
    terminal_mappings = false,
  })

  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit  = Terminal:new({
    cmd = "lazygit",
    dir = "git_dir",
    hidden = true,
    direction = "float",
    float_opts = {
      border = "double",
    },
    env = {
      -- pip install neovim-remote
      -- TODO: ensure this is installed
      GIT_EDITOR = [[nvr -cc vsplit --remote-wait +'set bufhidden=wipe']],
    },
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.keymap.set('t', 'q', [[<Cmd>wincmd q<CR>]], { buffer = term.bufnr })
    end,
    on_close = function(term) end,
    count = 99,
  })

  function _lazygit_toggle()
    lazygit:toggle()
  end

  function _helix_toggle()
    local filename = vim.api.nvim_buf_get_name(0)
    local line, column = unpack(vim.api.nvim_win_get_cursor(0))
    local helix = Terminal:new({
      cmd = "hx " .. filename .. ":" .. line .. ":" .. column,
      dir = "git_dir",
      hidden = true,
      direction = "float",
      float_opts = {
        border = "double",
      },
      count = 98,
      on_close = function(_)
        -- reload the file to apply any edits from hx
        vim.cmd('checktime')
      end,
    })
    helix:toggle()
  end

  vim.api.nvim_set_keymap("n", "<leader>l", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<leader>hx", "<cmd>lua _helix_toggle()<CR>", { noremap = true, silent = true })

  -- only want these mappings for toggle term
  vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
end

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-q>', [[<Cmd>wincmd q<CR>]], opts)
  vim.keymap.set('t', '<C-\\><C-\\>', [[<Cmd>wincmd q<CR>]], opts)
end

return M
