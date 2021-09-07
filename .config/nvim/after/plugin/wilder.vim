call wilder#setup({
            \ 'modes': [':', '/', '?'],
            \ 'next_key': '<Tab>',
            \ 'previous_key': '<S-Tab>',
            \ 'accept_key': '<Down>',
            \ 'reject_key': '<Up>',
            \ })

call wilder#set_option('pipeline', [
            \   wilder#branch(
            \     [
            \       wilder#check({_, x -> empty(x)}),
            \       wilder#history(),
            \       wilder#result({
            \         'draw': [{_, x -> ' ' . x}],
            \       }),
            \     ],
            \     wilder#python_file_finder_pipeline({
            \       'file_command': {_, arg -> stridx(arg, '.') != -1 ? ['fd', '-tf', '-H'] : ['fd', '-tf']},
            \       'dir_command': ['fd', '-td'],
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
            \       'fuzzy_filter': has('nvim') ? wilder#lua_fzy_filter() : wilder#vim_fuzzy_filter(),
            \     }),
            \     wilder#python_search_pipeline({
            \       'pattern': wilder#python_fuzzy_pattern({
            \         'start_at_boundary': 0,
            \       }),
            \     }),
            \   ),
            \ ])

let s:highlighters = [
            \ wilder#pcre2_highlighter(),
            \ has('nvim') ? wilder#lua_fzy_highlighter() : wilder#cpsm_highlighter(),
            \ ]

let s:popupmenu_renderer = wilder#popupmenu_renderer({
            \ 'highlighter': s:highlighters,
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
            \ 'highlighter': s:highlighters,
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
