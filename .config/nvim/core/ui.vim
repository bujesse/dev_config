set background=dark
let s:target_background = 'medium'
let s:target_palette = 'mix'

let g:gruvbox_material_background = s:target_background
let g:gruvbox_material_statusline_style = s:target_palette
let g:gruvbox_material_palette = s:target_palette
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_visual = 'green background'
let g:gruvbox_material_diagnostic_virtual_text = 'colored'

function! s:gruvbox_material_custom() abort
  " Link a highlight group to a predefined highlight group.
  " See `https://github.com/sainnhe/gruvbox-material/blob/master/colors/gruvbox-material.vim` for all predefined highlight groups.
  " highlight! link groupC groupD
  " highlight! link groupA groupB

  " Initialize the color palette.
  " The first parameter is a valid value for `g:gruvbox_material_background`,
  " and the second parameter is a valid value for `g:gruvbox_material_palette`.
  let l:palette = gruvbox_material#get_palette(s:target_background, s:target_palette)

  " Define a highlight group.
  " The first parameter is the name of a highlight group,
  " the second parameter is the foreground color,
  " the third parameter is the background color,
  " the fourth parameter is for UI highlighting which is optional,
  " and the last parameter is for `guisp` which is also optional.
  " See `autoload/gruvbox_material.vim` for the format of `l:palette`.
  " call gruvbox_material#highlight('groupE', l:palette.red, l:palette.none, 'undercurl', l:palette.red)
  call gruvbox_material#highlight('CurrentWord', l:palette.none, l:palette.bg_visual_red)
  call gruvbox_material#highlight('Search', l:palette.bg0, l:palette.bg5)
endfunction

augroup GruvboxMaterialCustom
  autocmd!
  autocmd ColorScheme gruvbox-material call s:gruvbox_material_custom()
augroup END

colorscheme gruvbox-material
