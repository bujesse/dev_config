local M = {}

function M.config()
  require('mason').setup({
    ui = {
      border = 'rounded',
      icons = {
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗'
      },
      keymaps = {
        toggle_package_expand = '<CR>',
        install_package = 'i',
        update_package = 'u',
        check_package_version = 'v',
        update_all_packages = 'U',
        check_outdated_packages = 'c',
        uninstall_package = 'x',
        cancel_installation = '<C-c>',
        apply_language_filter = '<C-f>',
      },
    }
  })
end

return M
