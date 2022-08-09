if executable('nkf')
  function! s:nkf(has_bang, ...) abort range
    execute 'silent' a:firstline ',' a:lastline '!nkf -Z0'
  endfunction

  command! -bar -bang -range=% -nargs=? Nkf  <line1>,<line2>call s:nkf(<bang>0, <f-args>)
endif
