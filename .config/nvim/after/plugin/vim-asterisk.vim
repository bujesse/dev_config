" Keep cursor position across matches
let g:asterisk#keeppos = 1

" Search selected text.
" Smartcase as default behavior.

" z* motions doesn't move your cursor.
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)
