" nkfコマンドが実行可能な場合
" 行Visualで指定した範囲に対して `nkf -Z0` （全角英数字・記号→半角に変換）を行う
if executable('nkf')
  function! s:nkf(has_bang, ...) abort range
    execute 'silent' a:firstline ',' a:lastline '!nkf -Z0'
  endfunction

  command! -bar -bang -range=% -nargs=? Nkf  <line1>,<line2>call s:nkf(<bang>0, <f-args>)
endif
