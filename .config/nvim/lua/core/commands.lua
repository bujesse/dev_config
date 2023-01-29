local M = {}

M.defaults = {
  [[
    function! QuickFixToggle()
      if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
      else
        cclose
      endif
    endfunction
  ]],
  [[
    function! TrimWhitespace()
      let l:save = winsaveview()
      keeppatterns %s/\s\+$//e
      call winrestview(l:save)
    endfun
  ]],
  -- Use like :Redir <command> to put output of whatever command in a new scratch window
  [[
    command -nargs=1 -complete=command Redir
        \ :execute "15new | pu=execute(\'" . <q-args> . "\') | setl nobuflisted buftype=nofile bufhidden=wipe noswapfile nu"
  ]],
  -- Put messages in a scratch
  [[
    command M
        \ :execute "Redir messages"
  ]],
}

M.load = function(commands)
  for _, command in ipairs(commands) do
    vim.cmd(command)
  end
end

function M.config()
  M.load(M.defaults)
end

return M
