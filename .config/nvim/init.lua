-- Initialize lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local core_modules = {
  'core.options',
  'core.globals',
  'plugins',
  'core.commands',
  'core.autocommands',
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
