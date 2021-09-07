local conditions = require('plugins.lualine.conditions')
local utils = require('core.utils')
-- https://github.com/LunarVim/LunarVim/blob/rolling/lua/core/lualine/components.lua

local function env_cleanup(venv)
  if string.find(venv, '/') then
    local final_venv = venv
    for w in venv:gmatch('([^/]+)') do
      final_venv = w
    end
    venv = final_venv
  end
  return venv
end

return {
  mode = {
    function()
      return ' '
    end,
    left_padding = 0,
    right_padding = 0,
    -- color = {},
    condition = nil,
  },
  branch = {
    'b:gitsigns_head',
    icon = ' ',
    -- color = { gui = "bold" },
    condition = conditions.hide_in_width,
  },
  filename = {
    'filename',
    -- color = {},
    condition = nil,
  },
  python_env = {
    function()
      if vim.bo.filetype == 'python' then
        local venv = os.getenv('CONDA_DEFAULT_ENV')
        if venv then
          return string.format(' %s', env_cleanup(venv))
        end
        venv = os.getenv('VIRTUAL_ENV')
        if venv then
          return string.format(' %s', env_cleanup(venv))
        end
        return ''
      end
      return ''
    end,
    -- color = { fg = colors.green },
    condition = conditions.hide_in_width,
  },
  diagnostics = {
    'diagnostics',
    sources = { 'nvim_lsp' },
    symbols = { error = '', warn = '', info = '', hint = '' },
    -- color = {},
    condition = conditions.hide_in_width,
  },
  treesitter = {
    function()
      if next(vim.treesitter.highlighter.active) then
        return '滑'
      end
      return ''
    end,
    -- color = { fg = colors.green },
    condition = conditions.hide_in_width,
  },
  lsp = {
    function(msg)
      msg = msg or '年'
      local buf_clients = vim.lsp.buf_get_clients()
      if next(buf_clients) == nil then
        return msg
      end

      local buf_client_names = {}

      -- add client
      for _, client in pairs(buf_clients) do
        if client.name ~= 'null-ls' then
          -- TODO: get the name of the language-server here
          table.insert(buf_client_names, '力')
        end
      end

      local buf_ft = vim.bo.filetype

      -- add formatter
      local formatters = require('plugins.lsp.null-ls.formatters')
      local supported_formatters = utils.map(formatters.list_supported_names(buf_ft), function(item)
        return ' ' .. item
      end)
      vim.list_extend(buf_client_names, supported_formatters)

      -- -- add linter
      local linters = require('plugins.lsp.null-ls.linters')
      local supported_linters = utils.map(linters.list_supported_names(buf_ft), function(item)
        return ' ' .. item
      end)
      vim.list_extend(buf_client_names, supported_linters)

      return table.concat(buf_client_names, '  ')
    end,
    -- color = { gui = "bold" },
    condition = conditions.hide_in_width,
  },
  location = {
    'location',
    condition = conditions.hide_in_width,
    color = {},
  },
  progress = {
    'progress',
    condition = conditions.hide_in_width,
    color = {},
  },
  spaces = {
    function()
      local label = 'Spaces: '
      if not vim.api.nvim_buf_get_option(0, 'expandtab') then
        label = 'Tab size: '
      end
      return label .. vim.api.nvim_buf_get_option(0, 'shiftwidth') .. ' '
    end,
    condition = conditions.hide_in_width,
    -- color = {},
  },
  encoding = {
    'o:encoding',
    upper = true,
    -- color = {},
    condition = conditions.hide_in_width,
  },
  filetype = {
    'filetype',
    condition = conditions.hide_in_width,
    color = {},
  },
  scrollbar = {
    function()
      local current_line = vim.fn.line('.')
      local total_lines = vim.fn.line('$')
      local chars = { '__', '▁▁', '▂▂', '▃▃', '▄▄', '▅▅', '▆▆', '▇▇', '██' }
      local line_ratio = current_line / total_lines
      local index = math.ceil(line_ratio * #chars)
      return chars[index]
    end,
    left_padding = 0,
    right_padding = 0,
    -- color = { fg = colors.yellow, bg = colors.bg },
    condition = nil,
  },
}
