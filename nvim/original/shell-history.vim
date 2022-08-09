if executable('show-history.sh')
  " TODO: Scratchコマンドの有無とシェルスクリプトの有無の確認が必要
  function! s:showShellHistory()
    execute 'botright' 10 'new'
    setlocal nobuflisted bufhidden=unload buftype=nofile
    :read !show-history.sh
    :norm gg
    setlocal nomodified
    setlocal readonly
  endfunction

  " g/<regexp>/d や v/<regexp>/d などしてフィルタはその後行う
  command! -nargs=0 ShowShellHistory :call s:showShellHistory()
endif
