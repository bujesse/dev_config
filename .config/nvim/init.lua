-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

local core_modules = {
  'core.options',
  'core.globals',
  'core.lazy',
  'core.commands',
  'core.autocommands',
  'core.keymappings',
  'core.macros',
}

if vim.g.neovide then
  table.insert(core_modules, 'core.neovide')
end

for _, module_name in ipairs(core_modules) do
  local ok, module = pcall(require, module_name)
  if ok then
    module.config()
  else
    error('Error loading ' .. module_name .. '\n\n' .. module)
  end
end
