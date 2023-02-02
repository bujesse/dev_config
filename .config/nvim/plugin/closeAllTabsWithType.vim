function! CloseAllTabsWithFiletype(targetFt)
  try
    for t in range(1, tabpagenr('$'))
      for b in tabpagebuflist(t)
        let ft = getbufvar(b, '&filetype')
        if ft == a:targetFt
          execute 'tabc' . t
          echo a:targetFt . ' closed'
        endif
      endfor
    endfor
  finally
    " go back to our original tab page
    " execute 'tabnext' l:currentTab
  endtry
endfunction
