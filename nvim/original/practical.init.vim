" ビジュアルモードで選択した内容を、シェルコマンドとして実行する（bレジスタを汚す）
xnoremap <Leader>! "by:let res = "Execute: " .@b . "\n"<CR>:let res = res . system(@b)<CR>:echo res<CR>

" vim-jp
" ビジュアルモードで選択中の文字列を特定のコマンドに渡す
xnoremap <Leader>e <Esc>gv"zy:<C-u>echo "<C-r>z"
