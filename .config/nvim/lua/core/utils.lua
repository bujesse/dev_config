local M = {}
M.selected_text = function()
  -- Get visually selected text
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})
  text = string.gsub(text, '\n', '')
  if string.len(text) == 0 then
    text = nil
  end
  return text
end

M.map = function(tbl, f)
  -- typical map function
  local t = {}
  for k, v in pairs(tbl) do
    t[k] = f(v)
  end
  return t
end

function P(obj)
  print(vim.inspect(obj))
  return obj
end

-- hide statusline
-- tables fetched from load_config function
-- M.hide_statusline = function()
--   local hidden = {
--     'startify',
--     'dashboard',
--     'terminal',
--   }
--   local shown = {}
--   local buftype = vim.api.nvim_buf_get_option('%', 'ft')

--   -- shown table from config has the highest priority
--   if vim.tbl_contains(shown, buftype) then
--     vim.api.nvim_set_option('laststatus', 2)
--     return
--   end

--   if vim.tbl_contains(hidden, buftype) then
--     vim.api.nvim_set_option('laststatus', 0)
--     return
--   else
--     vim.api.nvim_set_option('laststatus', 2)
--   end
-- end

-- load plugin after entering vim ui
M.packer_lazy_load = function(plugin, timer)
  if plugin then
    timer = timer or 0
    vim.defer_fn(function()
      require('packer').loader(plugin)
    end, timer)
  end
end

M.sep = (function()
  if jit then
    local os = string.lower(jit.os)
    if os == "linux" or os == "osx" or os == "bsd" then
      return "/"
    else
      return "\\"
    end
  else
    return package.config:sub(1, 1)
  end
end)()

return M
