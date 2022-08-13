" TODO: grepできるバージョンも作りたい
if executable('show-history.sh')
  function! s:showShellHistory()
    execute 'botright' 10 'new'
    setlocal nobuflisted bufhidden=unload buftype=nofile
    :read !show-history.sh
    :norm gg
    setlocal nomodified
    " setlocal readonly
  endfunction

  " g/<regexp>/d や v/<regexp>/d などしてフィルタはその後行う
  command! -nargs=0 ShellHistory :call s:showShellHistory()
endif
