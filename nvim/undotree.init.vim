" if has("persistent_undo")
"    " ファイルを閉じてもUndo記録を残す
"     set undodir=$XDG_CACHE_HOME/undodir/
"     set undofile
" endif
let g:undotree_WindowLayout = 2         " undotreeは左側/diffは下にウィンドウ幅で表示
let g:undotree_ShortIndicators = 1      " 時間単位は短く表示
let g:undotree_SplitWidth = 40          " undotreeのウィンドウ幅
let g:undotree_SetFocusWhenToggle = 1   " undotreeを開いたらフォーカスする
"let g:undotree_DiffAutoOpen = 0         " diffウィンドウは起動時無効
let g:undotree_DiffpanelHeight = 8      " diffウィンドウの行数
"let g:undotree_HighlightChangedText = 0 " 変更箇所のハイライト無効
" undotreeをトグル表示
noremap <Leader>u :UndotreeToggle<CR>

" undotreeバッファ内でのキーバインド設定
function! g:Undotree_CustomMap()
    map <silent> <buffer> <Esc> q
    map <silent> <buffer> h ?
endfunction
