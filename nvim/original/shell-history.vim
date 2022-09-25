if getftype(expand('$HOME') . '/.zhistory') != ""
  function! s:showShellHistory(...)
    execute 'botright' 10 'new'
    setlocal nobuflisted bufhidden=unload buftype=nofile
    read !tac $HOME/.zhistory | cut -b 16- | head -n 5000
    if a:0 == 1
      let l:exe_com = 'v/' . a:1 . '/d'
      execute l:exe_com
    endif
    norm gg
    setlocal nomodified
  endfunction

  command! -nargs=? ShellHistory :call s:showShellHistory(<f-args>)
endif
