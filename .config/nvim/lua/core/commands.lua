local M = {}

M.defaults = {
  Redir = {
    -- Use like :Redir <command> to put output of whatever command in a new scratch window
    command = [[:execute "15new | pu=execute(\'" . <q-args> . "\') | setl nobuflisted buftype=nofile bufhidden=wipe noswapfile nu"]],
    opts = {
      nargs = 1,
      complete = 'command',
    }
  },
  M = {
    command = ':execute "Redir messages"'
  },
}

M.load = function(commands)
  for name, command in pairs(commands) do
    vim.api.nvim_create_user_command(name, command.command, command.opts or {})
  end
end

function M.config()
  M.load(M.defaults)
end

return M
