" FIXME: sedのエラーを回避したい（Vim scriptで全部やるべき）
" show zsh command history
if getftype(expand('$HOME') . '/.zhistory') != ""
  function! s:showShellHistory(...)
    execute 'botright' 10 'new'
    setlocal nobuflisted bufhidden=unload buftype=nofile
    silent read !cat $HOME/.zhistory | cut -b 16- | head -n 5000
    " silent read !cat $HOME/.zhistory |
    "       \ grep '^:' |
    "       \ cut -b 3-12 -b 16- |
    "       \ sed -r '2,$s/([0-9]{10})/\1@@@/' |
    "       \ awk -F '@@@' '/[0-9]{10}/ { printf("\%s; \%s\n", strftime("\%Y-\%m-\%d \%H:\%M:\%S", $1), $2) }' |
    "       \ head -n 5000
    if a:0 == 1
      let l:exe_com = 'v/' . a:1 . '/d'
      execute l:exe_com
    endif
    norm G
    setlocal nomodified
  endfunction

  " filter by strings given by the argument
  command! -nargs=? ShellHistory :call s:showShellHistory(<f-args>)
endif
