local M = {}
function M.selected_text()
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

function M.map(tbl, f)
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

return M
