" ビジュアルモードで選択した内容を、シェルコマンドとして実行する（bレジスタを汚す）
xnoremap <Leader>! "by:let res = "Execute: " .@b . "\n"<CR>:let res = res . system(@b)<CR>:echo res<CR>
