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

-- -- Move hover docs to new buffer
-- M.hover = function()
--   local vim_util = require('vim.lsp.util')
--   vim.lsp.buf_request(0, 'textDocument/hover', vim_util.make_position_params(0, 'utf-8'), function(_, result, ctx, config)
--     config = config or {}
--     config.focus_id = ctx.method
--     if not (result and result.contents) then
--       -- return { 'No information available' }
--       return
--     end
--     local markdown_lines = vim_util.convert_input_to_markdown_lines(result.contents)
--     -- trims beg and end of whole content
--     markdown_lines = vim_util.trim_empty_lines(markdown_lines)
--     if vim.tbl_isempty(markdown_lines) then
--       return
--     end

--     local ft = vim.bo.filetype

--     -- print(dump(markdown_lines))
--     vim.api.nvim_command([[ new ]])
--     vim.api.nvim_buf_set_lines(0, 0, 1, false, markdown_lines)
--     vim.api.nvim_command('setlocal ft=' .. ft .. ' buftype+=nofile nobl conceallevel=2 concealcursor+=n')
--     vim.api.nvim_command([[ nnoremap <buffer>q <C-W>c ]])
--     -- vim.api.nvim_command [[ setlocal ft=lsp_markdown ]]
--   end)
-- end

-- Return the directory of the current buffer
M.get_buffer_dir = function()
  return vim.api.nvim_buf_get_name(0):match('(.*/)')
end

return M
