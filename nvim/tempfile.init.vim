" 一時ファイルを作成して開くコマンド
:command! OpenTempfile :edit `=tempname()`

" 日付、時刻を挿入する<C-A>dt, <C-A>tsを定義
" :でコマンドラインモードに入ったあとに使える
cnoremap <expr> <C-A>dt strftime('%Y%m%d')
cnoremap <expr> <C-A>ts strftime('%Y%m%d%H%M')

