local plugin_loader = {}

function plugin_loader:init()
  local install_path = DATA_PATH .. '/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd('packadd packer.nvim')
  end

  local packer_ok, packer = pcall(require, 'packer')
  if not packer_ok then
    return
  end

  local util = require('packer.util')

  packer.init({
    display = {
      open_fn = function()
        return util.float({ border = 'rounded' })
      end,
    },
  })

  self.packer = packer
  return self
end

function plugin_loader:load(configurations)
  return self.packer.startup(function(use)
    for _, plugins in ipairs(configurations) do
      for _, plugin in ipairs(plugins) do
        use(plugin)
      end
    end
  end)
end

return {
  init = function()
    return plugin_loader:init()
  end,
}
