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
  -- :LvimInfo
  -- [[command! LvimInfo lua require('core.info').toggle_popup(vim.bo.filetype)]],
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
