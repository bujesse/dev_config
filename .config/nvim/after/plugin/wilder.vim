function! s:wilder_init() abort
call wilder#setup({
      \ 'modes': [':', '/', '?'],
      \ 'next_key': '<C-j>',
      \ 'previous_key': '<C-k>',
      \ 'accept_key': '<Down>',
      \ 'reject_key': '<Up>',
      \ })

call wilder#set_option('pipeline', [
      \   wilder#branch(
      \     [
        \       wilder#check({_, x -> empty(x)}),
        \       wilder#history(),
        \     ],
        \     wilder#python_file_finder_pipeline({
        \       'file_command': {_, arg -> stridx(arg, '.') != -1 ? ['fd', '-tf', '-H'] : ['fd', '-tf']},
        \       'dir_command': {_, arg -> stridx(arg, '.') != -1 ? ['fd', '-td', '-H'] : ['fd', '-td']}
        \     }),
        \     wilder#substitute_pipeline({
        \       'pipeline': wilder#python_search_pipeline({
        \         'skip_cmdtype_check': 1,
        \         'pattern': wilder#python_fuzzy_pattern({
        \           'start_at_boundary': 0,
        \         }),
        \       }),
        \     }),
        \     wilder#cmdline_pipeline({
        \       'fuzzy': 1,
        \       'fuzzy_filter': wilder#lua_fzy_filter(),
        \     }),
        \     wilder#python_search_pipeline({
        \       'pattern': wilder#python_fuzzy_pattern({
        \         'start_at_boundary': 0,
        \       }),
        \     }),
        \   ),
        \ ])

let s:popupmenu_renderer = wilder#popupmenu_renderer({
      \ 'highlighter': wilder#lua_fzy_highlighter(),
      \ 'left': [
        \   wilder#popupmenu_devicons(),
        \   wilder#popupmenu_buffer_flags(),
        \ ],
        \ 'right': [
          \   ' ',
          \   wilder#popupmenu_scrollbar(),
          \ ],
          \ })

let s:wildmenu_renderer = wilder#wildmenu_renderer({
      \ 'highlighter': wilder#lua_fzy_highlighter(),
      \ 'apply_incsearch_fix': 0,
      \ 'separator': ' · ',
      \ 'left': [' ', wilder#wildmenu_spinner(), ' '],
      \ 'right': [' ', wilder#wildmenu_index()],
      \ })

call wilder#set_option('renderer', wilder#renderer_mux({
      \ ':': s:popupmenu_renderer,
      \ '/': s:wildmenu_renderer,
      \ 'substitute': s:wildmenu_renderer,
      \ }))
endfunction

" Set up an autocmd to defer initialisation to the first CmdlineEnter
" autocmd CmdlineEnter * ++once call s:wilder_init() | call s:wilder#main#start()
