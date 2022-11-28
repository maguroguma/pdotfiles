if executable('trans')
  function! s:printToTempBuffer(exe_command)
    execute 'botright' 10 'new'
    setlocal nobuflisted bufhidden=unload buftype=nofile
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

  " 英和 - :Enja <english word>
  command! -nargs=1 Enja :call s:engToJapa(<f-args>)
  " 和英 - :Jaen <日本語の単語>
  command! -nargs=1 Jaen :call s:japaToEng(<f-args>)
endif
