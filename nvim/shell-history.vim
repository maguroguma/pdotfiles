if executable('show-history.sh')
  " TODO: Scratchコマンドの有無とシェルスクリプトの有無の確認が必要
  function! s:showShellHistory()
    :Scratch
    :norm ggVGd
    :read !show-history.sh
    :norm gg
  endfunction

  " g/<regexp>/d や v/<regexp>/d などしてフィルタはその後行う
  command! -nargs=0 ShowShellHistory :call s:showShellHistory()
endif
