let s:denite_win_width_percent = 0.85
let s:denite_win_height_percent = 0.7

" Change denite default options
call denite#custom#option('default', {
    \ 'split': 'floating',
    \ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
    \ 'wincol': float2nr((&columns - (&columns * s:denite_win_width_percent)) / 2),
    \ 'winheight': float2nr(&lines * s:denite_win_height_percent),
    \ 'winrow': float2nr((&lines - (&lines * s:denite_win_height_percent)) / 2),
    \ })

" Deniteのprefixに<C-o>を使うためにリマップ（<C-->の指定の仕方が不明だったため妥協）
nnoremap - <C-o>
" Deniteの新しい設定(https://qiita.com/pyama2000/items/fafdbc77f394e71a9dd8)
" <C-d> は下スクロールのために残したいので <C-o>をprefixとする
" 【Ctrl + o + a】 カレントディレクトリとバッファを表示
nnoremap <silent><C-o><C-a> :<C-u>Denite file buffer -split=floating file:new<CR>
nnoremap <silent><C-o>a :<C-u>Denite file buffer -split=floating file:new<CR>
" 【Ctrl + o + b or o】 バッファを表示
nnoremap <silent><C-o><C-b> :<C-u>Denite buffer -split=floating file:new<CR>
nnoremap <silent><C-o>b :<C-u>Denite buffer -split=floating file:new<CR>
nnoremap <silent><C-o><C-o> :<C-u>Denite buffer -split=floating file:new<CR>
nnoremap <silent><C-o>o :<C-u>Denite buffer -split=floating file:new<CR>
" 【Ctrl + o + f】 カレントディレクトリを表示
nnoremap <silent><C-o><C-f> :<C-u>Denite file -split=floating file:new<CR>
nnoremap <silent><C-o>f :<C-u>Denite file -split=floating file:new<CR>
" 【Ctrl + o + r】 カレントディレクトリ以下を再帰的に表示
nnoremap <silent><C-o><C-r> :<C-u>Denite file/rec -split=floating file:new<CR>
nnoremap <silent><C-o>r :<C-u>Denite file/rec -split=floating file:new<CR>
" 【Ctrl + o + gr】 カレントディレクトリ以下のファイルから指定した文字列を検索
nnoremap <silent><C-o>gr :<C-u>Denite grep -split=floating -buffer-name=search<CR>
" 【Ctrl + o + ,】 カレントディレクトリ以下のファイルからカーソル下の文字列を検索
nnoremap <silent><C-o>, :<C-u>DeniteCursorWord grep -split=floating -buffer-name=search line<CR>
" 【Ctrl + o + gs】 grepした結果を再表示
nnoremap <silent><C-o>gs :<C-u>Denite -resume -split=floating -buffer-name=search<CR>
" 【Ctrl + o + c】 Neovim内で実行したコマンドを表示
nnoremap <silent><C-o>c :<C-u>Denite command_history -split=floating<CR>

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  " 【o】 ファイルを開く
  " nnoremap <silent><buffer><expr> o
  " \ denite#do_map('do_action')
  " 【s】 ウィンドウを水平分割してファイルを開く
  nnoremap <silent><buffer><expr> s
  \ denite#do_map('do_action', 'split')
  " 【v】 ウィンドウを垂直分割してファイルを開く
  nnoremap <silent><buffer><expr> v
  \ denite#do_map('do_action', 'vsplit')
  " 【d】 ファイルを削除する ->
  " 。。ではなくて、多分バッファを閉じるだけ、超便利
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  " 【p】 ファイルをプレビュー画面で開く
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  " 【ESC】 / 【q】 denite.nvimを終了する
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  " 【i】 ファイル名で検索する
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  " 【SPACE】 ファイルを複数選択する
  nnoremap <silent><buffer><expr> o
  \ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

" Deniteとagの連携(https://qiita.com/hrsh7th@github/items/e405b4f4228e10a43201)
" file/rec に ag を設定
let s:ignore_globs = ['.git', '.svn', 'node_modules']
" そもそも ag のレベルで検索対象からはずす
call denite#custom#var('file/rec', 'command', [
      \ 'ag',
      \ '--follow',
      \ ] + map(deepcopy(s:ignore_globs), { k, v -> '--ignore=' . v }) + [
      \ '--nocolor',
      \ '--nogroup',
      \ '-g',
      \ ''
      \ ])
" matcher/ignore_globs 以外のお好みの matcher を指定する
call denite#custom#source('file/rec', 'matchers', ['matcher/substring'])
" 他のソース向けに ignore_globs 自体は初期化
call denite#custom#filter('matcher/ignore_globs', 'ignore_globs', s:ignore_globs)
" プロンプト
call denite#custom#option('default', 'prompt', '>')
