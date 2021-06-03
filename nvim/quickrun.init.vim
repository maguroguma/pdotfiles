" https://besier.hatenadiary.org/entry/20140605/1401961885
" 一時ファイルを作成
nnoremap ,ot :e `tempname()`<CR>

" quickrun.vim
nnoremap <silent> ,vb :QuickRun -type vim<CR>
nnoremap <silent> ,vn :QuickRun -type vim -outputter null<CR>
vnoremap <silent> ,vb :QuickRun -type vim<CR>
vnoremap <silent> ,vn :QuickRun -type vim -outputter null<CR>

" https://qiita.com/844196/items/879db6528999ccf470b8
" :QuickRun json
" :'<,'>QuickRun json                 " 矩形選択中の部分を整形したい場合
" :QuickRun json -cmdopt '.hoge.fuga' " jqに引数を渡したい場合 (デフォルトは↑で設定した'.')
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config.json = {
    \ 'outputter/buffer/filetype': 'json',
    \ 'command': 'jq',
    \ 'cmdopt': '.',
    \ 'exec': 'cat %s | %c %o',
    \ }
