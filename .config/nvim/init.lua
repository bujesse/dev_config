-- Load this before the first 'require'
require('impatient')

local core_modules = {
  'core.options',
  'core.globals',
  'core.commands',
  'core.autocommands',
  'plugins',
  'core.keymappings',
  'core.macros',
}

for _, module_name in ipairs(core_modules) do
  local ok, module = pcall(require, module_name)
  if ok then
    module.config()
  else
    error('Error loading ' .. module_name .. '\n\n' .. module)
  end
end

-- Manually load this so impatient can cache it
require('packer_compiled')
