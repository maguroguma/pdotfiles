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
" 画面分割、移動、タブ
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 行頭、行末移動（もともとのH, Lは表示領域中でのカーソルの画面最上部・最下部への移動）
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L $

" 検索ワードを移動したらzz
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz

nnoremap s <Nop>
" 水平分割、垂直分割
nnoremap s- :<C-u>sp<CR>
nnoremap s<Bar> :<C-u>vs<CR>
" 分割画面移動
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap sw <C-w>w
" 分割した画面の移動（入れ替え）
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sr <C-w>r
" 新規タブ、タブ切り替え（snとspについては本来逆にすべきだが、現在のthemeではどうしてもしっくりこないので逆にしている）
" nnoremap st :<C-u>tabnew<CR>
" nnoremap sn gT
" nnoremap sp gt
" nnoremap tq :<C-u>tabclose<CR>
" 画面サイズを正規化（最大化など）
nnoremap s= <C-w>=
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
" 閉じる
" nnoremap sq :<C-u>q<CR>
nnoremap sq :<C-u>confirm quit<CR>
nnoremap sQ :<C-u>bd<CR>
" バッファ関連（？）
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>
" バッファが編集中でもその他のファイルを開けるように
set hidden

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader周り
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let mapleader = "\<Space>"

" おおまかに動く（パラグラフごとはあまり好きではない）
nnoremap <Leader>j 10gj
nnoremap <Leader>k 10gk
vnoremap <Leader>j 10gj
vnoremap <Leader>k 10gk
nnoremap J 10gj
nnoremap K 10gk
vnoremap J 10gj
vnoremap K 10gk

" 画面分割をtmuxぽく
" nnoremap <Leader>- :<C-u>sp<CR>
" nnoremap <Leader><Bar> :<C-u>vs<CR>
" 縦方向に画面サイズを均一化

nnoremap <Leader>w :w<CR>
" バッファを破棄してカレントファイルをリロード
nnoremap <Leader>e :e!<CR>

" init.vimの編集（リロードはなぜかできないので手動でやる必要がある）
" nnoremap <Leader>. :e $HOME/.config/nvim/init.vim<CR>

" 相対行トグル
" nnoremap <silent> <Leader>l :set relativenumber!<CR>

" クリップボードレジスタを使ったヤンク・ペースト・削除
vmap <Leader>y "+y
vmap <Leader>d "+d
vmap <Leader>p "+p
vmap <Leader>P "+P
nmap <Leader>y "+y
nmap <Leader>d "+d
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
cnoremap <C-r><C-r> <C-r>"
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
