local M = {}

M.get_colors = function()
  local colors = vim.fn['gruvbox_material#get_palette'](M.GRUVBOX_TARGET_BACKGROUND, M.GRUVBOX_TARGET_PALETTE)

  -- Reduce to only the hex values (gruvbox_material returns 2 values)
  colors = require('core.utils').map(colors, function(item)
    return item[1]
  end)
  return colors
end

M.config = function()
  vim.cmd([[set background=dark]])
  M.GRUVBOX_TARGET_BACKGROUND = 'medium'
  M.GRUVBOX_TARGET_PALETTE = 'mix'

  vim.g.gruvbox_material_background = M.GRUVBOX_TARGET_BACKGROUND
  vim.g.gruvbox_material_statusline_style = M.GRUVBOX_TARGET_PALETTE
  vim.g.gruvbox_material_palette = M.GRUVBOX_TARGET_PALETTE
  vim.g.gruvbox_material_enable_bold = 1
  vim.g.gruvbox_material_enable_italic = 1
  vim.g.gruvbox_material_visual = 'green background'
  vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'

  vim.g.gruvbox_material_sign_column_background = 'none'
  -- Don't show end of buffer tilde
  vim.g.gruvbox_material_show_eob = 0

  vim.cmd([[
  function! Gruvbox_material_custom() abort
    let l:palette = gruvbox_material#get_palette(g:gruvbox_material_background, g:gruvbox_material_palette)

    call gruvbox_material#highlight('CurrentWord', l:palette.none, l:palette.bg_visual_red)
    call gruvbox_material#highlight('Search', l:palette.bg0, l:palette.grey1)
  endfunction
  ]])

  require('core.autocommands').define_augroups({
    GruvboxMaterialCustom = {
      {
        'ColorScheme',
        'gruvbox-material',
        'call Gruvbox_material_custom()',
      },
    },
  })

  -- augroup GruvboxMaterialCustom
  -- autocmd!
  -- autocmd ColorScheme gruvbox-material call s:gruvbox_material_custom()
  -- augroup END

  -- Get rid of line between splits
  -- hi VertSplit guibg=bg guifg=bg

  -- Get rid of end of buffer tilde
  -- hi EndOfBuffer guifg=bg

  vim.cmd('colorscheme gruvbox-material')
end

return M
