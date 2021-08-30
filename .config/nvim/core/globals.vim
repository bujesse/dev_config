" Make neovim always use global python3 so the 'pynim' package is not required
" for each virtualenv
let g:python3_host_prog = '/usr/bin/python3'

" Disable python 2
let g:loaded_python_provider = 0
let g:python_pep8_indent_searchpair_timeout = 10

