set background=dark
let g:gruvbox_target_background = 'medium'
let g:gruvbox_target_palette = 'mix'

let g:gruvbox_material_background = g:gruvbox_target_background
let g:gruvbox_material_statusline_style = g:gruvbox_target_palette
let g:gruvbox_material_palette = g:gruvbox_target_palette
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_visual = 'green background'
let g:gruvbox_material_diagnostic_virtual_text = 'colored'

let g:gruvbox_material_sign_column_background='none'
" Don't show end of buffer tilde
let g:gruvbox_material_show_eob= 0

function! s:gruvbox_material_custom() abort
  " Link a highlight group to a predefined highlight group.
  " See `https://github.com/sainnhe/gruvbox-material/blob/master/colors/gruvbox-material.vim` for all predefined highlight groups.
  " highlight! link groupC groupD
  " highlight! link groupA groupB

  " Initialize the color palette.
  " The first parameter is a valid value for `g:gruvbox_material_background`,
  " and the second parameter is a valid value for `g:gruvbox_material_palette`.
  let l:palette = gruvbox_material#get_palette(g:gruvbox_target_background, g:gruvbox_target_palette)

  " Define a highlight group.
  " The first parameter is the name of a highlight group,
  " the second parameter is the foreground color,
  " the third parameter is the background color,
  " the fourth parameter is for UI highlighting which is optional,
  " and the last parameter is for `guisp` which is also optional.
  " See `autoload/gruvbox_material.vim` for the format of `l:palette`.
  " call gruvbox_material#highlight('groupE', l:palette.red, l:palette.none, 'undercurl', l:palette.red)
  call gruvbox_material#highlight('CurrentWord', l:palette.none, l:palette.bg_visual_red)
  " call gruvbox_material#highlight('Search', l:palette.bg0, l:palette.bg5)
  call gruvbox_material#highlight('Search', l:palette.bg0, l:palette.grey1)
endfunction

augroup GruvboxMaterialCustom
  autocmd!
  autocmd ColorScheme gruvbox-material call s:gruvbox_material_custom()
augroup END

" Get rid of line between splits
" hi VertSplit guibg=bg guifg=bg

" Get rid of end of buffer tilde
" hi EndOfBuffer guifg=bg

colorscheme gruvbox-material
