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

function RELOAD(...)
  return require('plenary.reload').reload_module(...)
end

function R(name)
  RELOAD(name)
  return require(name)
end

M.sep = (function()
  if jit then
    local os = string.lower(jit.os)
    if os == 'linux' or os == 'osx' or os == 'bsd' then
      return '/'
    else
      return '\\'
    end
  else
    return package.config:sub(1, 1)
  end
end)()

---Get the character directly behind the current cursor
function M.get_cursor_prev_char()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  return string.sub(vim.api.nvim_get_current_line(), col, col)
end

---@param table table
---@param val any
---@return boolean
function M.table_contains(table, val)
  for _, value in ipairs(table) do
    if value == val then
      return true
    end
  end
  return false
end

return M
