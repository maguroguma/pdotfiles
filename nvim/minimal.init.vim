if exists('g:loaded_maguroguma_nvim_setting')
  finish
endif
let g:loaded_maguroguma_nvim_setting = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SECTION: depeding on environment
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:histfile_path = expand('~/.local/state/zsh_history')
if filereadable(s:histfile_path)
  " source
  function! s:list_command_history() abort
    let l:hist_com = 'cat ' .. s:histfile_path .. ' | cut -b 16- | head -n 5000'
    let l:res = system(l:hist_com)
    return reverse(split(l:res, "\n"))
  endfunction
  " sink
  function! s:insert_target(shell_command) abort
    call setline(line("."), a:shell_command)
  endfunction
  command! HCommand call fzf#run(fzf#wrap({
    \ 'source': s:list_command_history(),
    \ 'sink': funcref('s:insert_target'),
    \ 'options': '--ansi --prompt "replace current line> "',
  \ }))
  nnoremap <silent> R :HCommand<CR>
else
  echoerr '[ERROR] cannot read command history file: ' .. s:histfile_path
endif

set shell=/bin/zsh

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SECTION: start up
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ref: https://qiita.com/yasunori-kirin0418/items/4672919be73a524afb47
" Disable default plugins {{{
" Fast Startup Settings!!
" Disable TOhtml.
let g:loaded_2html_plugin       = v:true

" Disable archive file open and browse.
let g:loaded_gzip               = v:true
let g:loaded_tar                = v:true
let g:loaded_tarPlugin          = v:true
let g:loaded_zip                = v:true
let g:loaded_zipPlugin          = v:true

" Disable vimball.
let g:loaded_vimball            = v:true
let g:loaded_vimballPlugin      = v:true

" Disable netrw plugins.
let g:loaded_netrw              = v:true
let g:loaded_netrwPlugin        = v:true
let g:loaded_netrwSettings      = v:true
let g:loaded_netrwFileHandlers  = v:true

" Disable `GetLatestVimScript`.
let g:loaded_getscript          = v:true
let g:loaded_getscriptPlugin    = v:true

" Disable other plugins
let g:loaded_man                = v:true
let g:loaded_matchit            = v:true
" let g:loaded_matchparen         = v:true
let g:loaded_shada_plugin       = v:true
let g:loaded_spellfile_plugin   = v:true
let g:loaded_tutor_mode_plugin  = v:true
let g:did_install_default_menus = v:true
let g:did_install_syntax_menu   = v:true
let g:skip_loading_mswin        = v:true
let g:did_indent_on             = v:true
let g:did_load_ftplugin         = v:true
let g:loaded_rrhelper           = v:true
" }}}

" Automatic installation on startup(neovim + vim)
let s:jetpackfile = stdpath('data') .. '/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
let s:jetpackurl = "https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim"
if !filereadable(s:jetpackfile)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-jetpack yourself!"
    execute "q!"
  endif
  echo "Installing vim-jetpack..."
  echo ""
  call system(printf('curl -fsSLo %s --create-dirs %s', s:jetpackfile, s:jetpackurl))
endif

" minimal version
let s:minimal_jetpack_dir = stdpath('data') .. '/site/pack/jetpack/minimal/'

" manage plugins by jetpack
packadd vim-jetpack
call jetpack#begin(s:minimal_jetpack_dir)
call jetpack#add('nathom/filetype.nvim')

call jetpack#add('tani/vim-jetpack', { 'opt': 1 })
call jetpack#add('junegunn/fzf')
call jetpack#add('junegunn/fzf.vim')
call jetpack#add('rlane/pounce.nvim')
call jetpack#add('rhysd/committia.vim')
call jetpack#add('hotwatermorning/auto-git-diff')
call jetpack#add('lambdalisue/vim-manpager')

call jetpack#add('machakann/vim-sandwich')
call jetpack#add('markonm/traces.vim') " realize live substitute
call jetpack#add('EdenEast/nightfox.nvim')
call jetpack#end()

" Automatic plugin installation on startup
for name in jetpack#names()
  if !jetpack#tap(name)
    call jetpack#sync()
    break
  endif
endfor

" this settings need to be loaded first.
filetype plugin indent on
let mapleader="\<Space>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SECTION: plugin map
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(
    \   <q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}),
    \   <bang>0)

" popup window
let g:fzf_layout = { 'window': { 'width': 0.5, 'height': 0.4, 'yoffset': 0.5 } }

" Empty value to disable preview window altogether
let g:fzf_preview_window = []

nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <Space>q :History:<CR>

function! s:paste_file_paths(strings)
    let l:original_a = getreg('a')
    let l:joined_strings = join(a:strings, ' ')
    call setreg('a', l:joined_strings)
    normal! "ap
    call setreg('a', l:original_a)
endfunction
command! FzfPasteFilePaths call fzf#run(fzf#wrap({
  \ 'source': 'find .',
  \ 'sink*': { lines -> s:paste_file_paths(lines) },
  \ 'options': '--multi --ansi --prompt "replace current line> "',
\ }))
nnoremap <silent> F :FzfPasteFilePaths<CR>

nmap ' <cmd>Pounce<CR>
vmap ' <cmd>Pounce<CR>
omap g' <cmd>Pounce<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SECTION: original
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 今日の日付
inoremap <C-a>day <C-r>=strftime("%Y-%m-%d")<CR>
cnoremap <C-a>day <C-r>=strftime("%Y-%m-%d")<CR>
" 現在時刻
inoremap <C-a>time <C-r>=strftime("%Y-%m-%d %T")<CR>
" fzfで日付を入力したい
function g:TerminalDay()
  let l:temp = @z
  let @z = strftime("%Y-%m-%d")
  put! z
  let @z = l:temp
  norm a
endfunction
tnoremap <C-a>day <C-\><C-n>:call g:TerminalDay()<CR>

if executable('trans')
  function! s:printToTempBuffer(exe_command)
    execute 'botright' 10 'new'
    setlocal nobuflisted bufhidden=unload buftype=nofile
    execute a:exe_command
    norm gg
    setlocal nomodified
  endfunction

  function! s:engToJapa(arg)
    let l:com = 'read !trans en:ja -no-ansi ' . "'" . a:arg . "'"
    call s:printToTempBuffer(l:com)
  endfunction

  function! s:japaToEng(arg)
    let l:com = 'read !trans ja:en -no-ansi ' . "'" . a:arg . "'"
    call s:printToTempBuffer(l:com)
  endfunction

  " 英和 - :Enja <english word>
  command! -nargs=1 Enja :call s:engToJapa(<f-args>)
  " 和英 - :Jaen <日本語の単語>
  command! -nargs=1 Jaen :call s:japaToEng(<f-args>)
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SECTION: set options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set termguicolors

set nocompatible
syntax enable

set mouse=n

" fold
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable " Disable folding at startup.
set foldlevelstart=100

" 挿入モードでのバックスペースで改行が削除できない場合に設定する項目
set backspace=indent,eol,start

" 検索した際に最後の語句の次に最初の語句にループしないようにする
set nowrapscan

set fenc=utf-8
set encoding=utf8
set nobackup
set noswapfile
set autoread
set showcmd

set cursorline
set virtualedit=onemore
set autoindent
set smarttab
set smartindent
set visualbell
set showmatch
set laststatus=2
set wildmode=list:longest

set list listchars=tab:\^\-,trail:~,nbsp:%,eol:$
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=0

set ignorecase
set smartcase
set incsearch
set hlsearch

" txtファイルで自動改行を防ぐ
" https://loumo.jp/archives/10503
autocmd FileType text :set formatoptions=q

set title
set wildmenu
set history=200
set helplang=ja

set hidden

" 独自定義highlight
highlight CursorLine ctermbg=238
highlight CursorLine guibg=#383838
highlight Visual cterm=bold ctermfg=NONE ctermbg=24
highlight Visual gui=bold guifg=NONE guibg=#11607d
" highlight StatusLine cterm=bold ctermbg=193 ctermfg=0
" highlight StatusLineNC ctermbg=193
highlight NonText    ctermfg=239 ctermbg=None
highlight NonText    guifg=#3d3d3d guibg=None
highlight SpecialKey ctermfg=239 ctermbg=None
highlight SpecialKey guifg=#3d3d3d guibg=None
highlight Folded ctermfg=15 ctermbg=8
highlight Folded guifg=#fff9e6 guibg=#586358
highlight Search ctermfg=0 ctermbg=44
highlight Search guifg=#021f02 guibg=#43c5d9
highlight IncSearch cterm=bold ctermbg=44 ctermfg=0
highlight IncSearch gui=bold guifg=#021f02 guibg=#43c5d9

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SECTION: mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

" esc
inoremap <silent> jj <ESC>

" prefix
nnoremap s <Nop>
nnoremap t <Nop>
" nnoremap q <Nop>
nnoremap <Space> <Nop>

" macro
nnoremap Q q:
nnoremap ? q/

" cursor move
nnoremap j gj
nnoremap k gk
inoremap <C-h> <Left>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
nnoremap <Space>j 10gj
nnoremap <Space>k 10gk
vnoremap <Space>j 10gj
vnoremap <Space>k 10gk
nnoremap J 10gj
nnoremap K 10gk
vnoremap J 10gj
vnoremap K 10gk
nnoremap H ^
vnoremap H ^
nnoremap L $
vnoremap L $
nnoremap <C-h> ^
vnoremap <C-h> ^
nnoremap <C-l> $
vnoremap <C-l> $

" search
nnoremap n nzz
nnoremap N Nzz
nnoremap <ESC><ESC> :nohlsearch<CR>

" window
nnoremap s- :<C-u>sp<CR>
nnoremap s<Bar> :<C-u>vs<CR>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap s= <C-w>=
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
nnoremap sq :<C-u>confirm quit<CR>

" buffer
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz

" save, load
nnoremap <Space>w :w<CR>
nnoremap <Space>e :e!<CR>

" yank, paste
vmap <Space>y "+y
vmap <Space>p "+p
vmap <Space>P "+P
nmap <Space>y "+y
nmap <Space>p "+p
nmap <Space>P "+P
nnoremap <Space>Y ggVG"+y
nnoremap <Space>= ggVG=

" blackhole register
noremap x "_x
nnoremap D "_d
nnoremap C "_c
xnoremap D "_d
xnoremap C "_c

" register
inoremap <C-r><C-r> <C-r>"
inoremap <C-r>r <C-r>"
cnoremap <C-r><C-r> <C-r>"
cnoremap <C-r>r <C-r>"
inoremap <C-r><Space> <C-r>+
cnoremap <C-r><Space> <C-r>+

" for browsing the input history
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" toggle
nnoremap <Space>n :<C-u>set number!<CR>
nnoremap <Space>W :<C-u>set wrap!<CR>

augroup git-semantic-commit-message
  autocmd! *
  " https://zenn.dev/uochan/articles/2021-12-08-vim-conventional-commits
  function! g:SelectType() abort
    if &filetype !=? "gitcommit"
      echoerr 'This is not gitcommit buffer!'
      return
    endif

    let line = substitute(getline('.'), '^#\s*', '', 'g') " 最初の '# ' を除く
    let arr = split(line, ' ')
    let title = printf('%s: %s ', arr[0], arr[1])

    silent! normal! "_dip
    silent! put! =title
    silent! startinsert!
  endfunction
  autocmd FileType gitcommit nnoremap ZZ <cmd>call g:SelectType()<CR>
augroup END

highlight PounceMatch      cterm=underline,bold ctermfg=49 ctermbg=236 gui=underline,bold guifg=#555555 guibg=#FFAF60
highlight PounceGap        cterm=underline,bold ctermfg=214 ctermbg=236 gui=underline,bold guifg=#555555 guibg=#E27878
highlight PounceAccept     cterm=underline,bold ctermfg=184 ctermbg=236 gui=underline,bold guifg=#FFAF60 guibg=#555555
highlight PounceAcceptBest cterm=underline,bold ctermfg=196 ctermbg=236 gui=underline,bold guifg=#EE2513 guibg=#555555

lua <<EOF
require'pounce'.setup{
  accept_keys = "HJKLYUIOPNMQWERTASDFGZXCVB",
  accept_best_key = "<enter>",
  multi_window = true,
  debug = false,
}
EOF

" normal, insertともに<CR>で終了するようにする
nnoremap <CR> :wq<CR>
inoremap <CR> <Esc>:wq<CR>

colorscheme dayfox
