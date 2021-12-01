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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 挿入モードでのバックスペースで改行が削除できない場合に設定する項目
set backspace=indent,eol,start

" 検索した際に最後の語句の次に最初の語句にループしないようにする
set nowrapscan

" setting
"文字コードをUFT-8に設定
set fenc=utf-8
" vim-deviconsプラグインのための設定
set encoding=utf8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" 入力中のコマンドをステータスに表示する
set showcmd

" 見た目系
" 行番号を表示
" set number
" 行番号を相対表示
" set relativenumber
" 現在の行を強調表示
set cursorline
highlight CursorLine ctermbg=238
" 現在の行を強調表示（縦）
" set cursorcolumn
" highlight CursorColumn ctermbg=238
" ビジュアルモードの色を変更
highlight Visual cterm=bold ctermbg=darkblue ctermfg=NONE
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest

" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
" set list listchars=tab:\▸\-,trail:-,nbsp:%,eol:↲
set list listchars=tab:\^\-,trail:~,nbsp:%,eol:$
hi NonText    ctermbg=None ctermfg=239 guibg=NONE guifg=None
hi SpecialKey ctermbg=None ctermfg=239 guibg=NONE guifg=None
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2
" 行頭でのTab文字の表示幅
set shiftwidth=2

" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
"set wrapscan
" 検索語をハイライト表示
set hlsearch

" 自動改行を防ぐ
" https://loumo.jp/archives/10503
autocmd FileType text :set formatoptions=q

" クリップボードの共有
"set clipboard=unnamed

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" インデントあれこれ
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set autoindent          "改行時に前の行のインデントを計測
set smartindent         "改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set cindent             "Cプログラムファイルの自動インデントを始める
set smarttab            "新しい行を作った時に高度な自動インデントを行う
set expandtab           "タブ入力を複数の空白に置き換える

set tabstop=2           "タブを含むファイルを開いた際, タブを何文字の空白に変換するか
set shiftwidth=2        "自動インデントで入る空白数
set softtabstop=0       "キーボードから入るタブの数

" set cursorlineの設定
" https://thinca.hatenablog.com/entry/20090530/1243615055
augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
    if a:event ==# 'WinEnter'
      setlocal cursorline
      " setlocal cursorcolumn
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
      " setlocal nocursorcolumn
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          setlocal nocursorline
          " setlocal nocursorcolumn
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      setlocal cursorline
      " setlocal cursorcolumn
      let s:cursorline_lock = 1
    endif
  endfunction
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" https://qiita.com/jiroshin/items/ee86ea426a51fa24b319
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set shell=/bin/zsh
set title

" マスタリングVim
set wildmenu

" 実践Vim
set history=200
