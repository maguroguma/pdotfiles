if executable('trans')
  function! s:printToTempBuffer(exe_command)
    execute 'botright' 10 'new'
    setlocal nobuflisted bufhidden=unload buftype=nofile
    " 指定コマンドの実行
    execute a:exe_command
    norm gg
    setlocal nomodified
  endfunction

  function! s:engToJapa(arg)
    let l:com = 'read !trans en:ja -no-ansi ' . "'" . a:arg . "'"
    call s:printToTempBuffer(l:com)
  endfunction

  function! s:japaToEng(arg)
    let l:com = 'read !trans ja:en -no-ansi ' . "'" . a:arg . "'"
    call s:printToTempBuffer(l:com)
  endfunction

  command! -nargs=1 Enja :call s:engToJapa(<f-args>)
  command! -nargs=1 Jaen :call s:japaToEng(<f-args>)
endif
