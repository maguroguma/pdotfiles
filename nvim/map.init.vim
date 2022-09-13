"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 特殊キーの表記一覧
" https://vim.jp.net/stepuptonovice_input_mappings_keynotations.html
" Back Space  <BS>
" Tab         <Tab>
" Enter       <Enter> or <Return> or <CR>
" Escape      <Esc>
" Space       <Space>
" |           <Bar>
" Delete      <Del>
" 各種矢印    <Up><Down><Left><Right>
" Fn          <F1>...<F12>
" Home        <Home>
" End         <End>
" PageUp      <PageUp><PageDown>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" escのリマップ
inoremap <silent> jj <ESC>
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
" インサートモードでのカーソル移動
inoremap <C-h> <Left>
inoremap <C-l> <Right>
" コマンドモードでのカーソル移動
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" prefix
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap s <Nop>
nnoremap t <Nop>
nnoremap q <Nop>
nnoremap <Leader> <Nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 画面分割、移動、タブ
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 検索ワードを移動したらzz
nnoremap n nzz
nnoremap N Nzz
" map * *zz
" map # #zz

" 水平分割、垂直分割
nnoremap s- :<C-u>sp<CR>
nnoremap s<Bar> :<C-u>vs<CR>
" 分割画面移動
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
" 分割した画面の移動（入れ替え）
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
" 画面サイズを正規化（最大化など）
nnoremap s= <C-w>=
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
" 閉じる
nnoremap sq :<C-u>confirm quit<CR>
" バッファが編集中でもその他のファイルを開けるように
set hidden

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader周り
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" おおまかに動く（パラグラフごとはあまり好きではない）
nnoremap <Leader>j 10gj
nnoremap <Leader>k 10gk
vnoremap <Leader>j 10gj
vnoremap <Leader>k 10gk
nnoremap J 10gj
nnoremap K 10gk
vnoremap J 10gj
vnoremap K 10gk

nnoremap <Leader>w :w<CR>
nnoremap <Leader>e :e!<CR>

" クリップボードレジスタを使ったヤンク・ペースト・削除
vmap <Leader>y "+y
" vmap <Leader>d "+d
vmap <Leader>p "+p
vmap <Leader>P "+P
nmap <Leader>y "+y
" nmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
" 全体をクリップボードレジスタにヤンク
nnoremap <Leader>Y ggVG"+y
" 全体のインデントを整形する
nnoremap <Leader>= ggVG=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" レジスタ
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

inoremap <C-r><C-r> <C-r>"
inoremap <C-r>r <C-r>"
cnoremap <C-r><C-r> <C-r>"
cnoremap <C-r>r <C-r>"
inoremap <C-r><Space> <C-r>+
cnoremap <C-r><Space> <C-r>+

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" カスタマイズ
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 検索結果のハイライトをESCキーの連打でリセットする
nnoremap <ESC><ESC> :nohlsearch<CR>

" xによる削除はデフォルトレジスタを使わない
noremap x "_x

" 戻る・進むジャンプ後にzz
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz

" for browsing the input history（実践Vim）
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" マクロ周り, qはprefixとして使えるようにする
nnoremap Q q

" numberのトグル
nnoremap <Leader>n :<C-u>set number!<CR>

" mkviewコマンド、loadviewコマンドの関数化、マッピング
function! g:Mkview_and_echo_msg() abort
  mkview
  echo 'done mkview'
endfunction
function! g:Loadview_and_echo_msg() abort
  loadview
  echo 'done loadview'
endfunction
nnoremap <C-m> :<C-u>call g:Mkview_and_echo_msg()<CR>
nnoremap <C-l> :<C-u>call g:Loadview_and_echo_msg()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" マーク設定
" https://saihoooooooo.hatenablog.com/entry/2013/04/30/001908
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 基本マップ
nnoremap [Mark] <Nop>
nmap m [Mark]

" 現在位置をマーク
if !exists('g:markrement_char')
    let g:markrement_char = [
    \     'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    \     'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
    \ ]
endif
nnoremap <silent>[Mark]m :<C-u>call <SID>AutoMarkrement()<CR>
function! s:AutoMarkrement()
    if !exists('b:markrement_pos')
        let b:markrement_pos = 0
    else
        let b:markrement_pos = (b:markrement_pos + 1) % len(g:markrement_char)
    endif
    execute 'mark' g:markrement_char[b:markrement_pos]
    echo 'marked' g:markrement_char[b:markrement_pos]
endfunction

" 次/前のマーク
nnoremap [Mark]n ]`
nnoremap [Mark]p [`

" 一覧表示
nnoremap [Mark]l :<C-u>marks<CR>

" バッファ読み込み時にマークを初期化
autocmd BufReadPost * delmarks!
