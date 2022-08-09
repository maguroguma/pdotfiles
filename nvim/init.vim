"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" https://qiita.com/ryuta69/items/98901f4c4f0683e7aa57
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 起動時設定
if has('vim_starting')
  set nocompatible
endif

" vim-plugのチェック（未インストールであれば、curlでインストールの後、初期化を行う）
if !filereadable(expand('~/.local/share/nvim/site/autoload/plug.vim'))
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"
  autocmd VimEnter * PlugInstall
endif

" プラギン管理 (https://github.com/junegunn/vim-plug)
call plug#begin(expand('~/.local/share/nvim/plugged'))

" basic.init.vim
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-fugitive'
Plug 'vim-jp/vimdoc-ja'
Plug 'mattn/emmet-vim', { 'for' : ['html', 'vue', 'html.twig'] }
Plug 'luochen1990/rainbow'
Plug 'easymotion/vim-easymotion'
Plug 'ntpeters/vim-better-whitespace'

" statusline.init.vim
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" ultisnips
Plug 'sirver/ultisnips'

" Markdown
Plug 'mzlogin/vim-markdown-toc', { 'for': ['md', 'markdown'] }
Plug 'iamcco/mathjax-support-for-mkdp', { 'for': ['md', 'markdown'] }
" Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Markdown Preview
Plug 'previm/previm'

" golang.init.vim
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' }
Plug 'jodosha/vim-godebug', { 'for': 'go' }

" theme.init.vim
Plug 'w0ng/vim-hybrid'
Plug 'srcery-colors/srcery-vim'

" buffer.init.vim
" Plug 'moll/vim-bbye'
" Plug 'schickling/vim-bufonly'
" Plug 'jeetsukumaran/vim-buffergator'
Plug 'Asheq/close-buffers.vim'

" close-buffers.nvim
" Plug 'kazhala/close-buffers.nvim'

" coc.init.vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'iamcco/coc-tailwindcss',  {'do': 'yarn install --frozen-lockfile && yarn run build'}
Plug 'liuchengxu/vista.vim'

" fuzzy finder
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" memolist.init.vim
Plug 'glidenote/memolist.vim'

" grepper
Plug 'mhinz/vim-grepper'
Plug 'dyng/ctrlsf.vim'

" winresizer
Plug 'simeji/winresizer'

" wilder.nvim
if has('nvim')
  function! UpdateRemotePlugins(...)
    " Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
  endfunction

  Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
else
  Plug 'gelguy/wilder.nvim'

  " To use Python remote plugin features in Vim, can be skipped
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" vue plugins
Plug 'posva/vim-vue'
Plug 'tomtom/tcomment_vim'

" fern
" Plug 'lambdalisue/fern.vim'
" Plug 'antoinemadec/FixCursorHold.nvim'
" Plug 'lambdalisue/fern-git-status.vim'
" Plug 'lambdalisue/fern-hijack.vim'
" Plug 'LumaKernel/fern-mapping-fzf.vim'

" lir.nvim
Plug 'tamago324/lir.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'tamago324/lir-git-status.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" defx
if has('nvim')
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  " Plug 'kristijanhusak/defx-icons'
  Plug 'kristijanhusak/defx-git'
else
  Plug 'Shougo/defx.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  " Plug 'kristijanhusak/defx-icons'
  Plug 'kristijanhusak/defx-git'
endif

" denops
Plug 'vim-denops/denops.vim'
" Plug 'kat0h/bufpreview.vim'

" glance-vim(require denops)
" Plug 'tani/glance-vim'

" textobj
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-jabraces'
Plug 'osyo-manga/vim-textobj-multiblock'
Plug 'osyo-manga/vim-textobj-multitextobj'

" gina.vim
Plug 'lambdalisue/gina.vim'

" devdocs
Plug 'rhysd/devdocs.vim'

" vim-bookmarks
Plug 'MattesGroeger/vim-bookmarks'

" nvim-treesitter
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

" vim germanium(require denops and germanium)
Plug 'skanehira/denops-germanium.vim'

" vim-silicon(Rust)
Plug 'segeljakt/vim-silicon'

" nerdcommenter
" Plug 'preservim/nerdcommenter'

" floaterm
Plug 'voldikss/vim-floaterm'

" Plug 'rbtnn/vim-emphasiscursor'

" gitsigns.nvim
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'

" diffview.nvim
" Plug 'nvim-lua/plenary.nvim'
" Plug 'sindrets/diffview.nvim'

" lazygit.nvim
Plug 'kdheepak/lazygit.nvim'

" motion
Plug 'phaazon/hop.nvim'
Plug 'rlane/pounce.nvim'
" require denops
Plug 'yuki-yano/fuzzy-motion.vim'
Plug 'skanehira/denops-docker.vim'

" translate.vim
Plug 'skanehira/translate.vim'

" vim-asterisk
Plug 'haya14busa/vim-asterisk'

" qfopen.vim
Plug 'skanehira/qfopen.vim'

" committia.vim
Plug 'rhysd/committia.vim'

" Comment.nvim
" Plug 'numToStr/Comment.nvim'

" vim-doge
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

" glow.nvim
" Plug 'ellisonleao/glow.nvim'

" git-blame.nvim
" Plug 'f-person/git-blame.nvim'

" nvim-bqf
Plug 'kevinhwang91/nvim-bqf'

" nvim-hlslens
" Plug 'kevinhwang91/nvim-hlslens'

" specs.nvim
" Plug 'edluffy/specs.nvim'

" shade.nvim
" Plug 'sunjon/shade.nvim'

" pretty-fold.nvim
" Plug 'anuvyklack/pretty-fold.nvim'

" vim-illuminate(neovim)
Plug 'RRethy/vim-illuminate'

" registers.nvim
Plug 'tversteeg/registers.nvim'

" todo-comments.nvim
Plug 'nvim-lua/plenary.nvim'
Plug 'folke/todo-comments.nvim'

" nvim-scrollview
" Plug 'dstein64/nvim-scrollview', { 'branch': 'main' }

" sniprun(neovim)
Plug 'michaelb/sniprun', {'do': 'bash install.sh'}
" 'bash install.sh 1' to get the bleeding edge or if you have trouble with the precompiled binary,
"  but you'll compile sniprun at every update & will need the rust toolchain

" Japanese Text
Plug 'deton/jasegment.vim'

" vim-quickhl
Plug 't9md/vim-quickhl'

" vim-edgemotion
Plug 'haya14busa/vim-edgemotion'

" vim-rengbang
Plug 'deris/vim-rengbang'

" nvim-spectre
Plug 'nvim-lua/plenary.nvim'
Plug 'windwp/nvim-spectre'

" which-key.nvim
Plug 'folke/which-key.nvim'

" dial.nvim
Plug 'monaqa/dial.nvim'

" vim-print-debug
Plug 'sentriz/vim-print-debug'

" legendary.nvim (requires neovim 0.7.0)
" Plug 'mrjones2014/legendary.nvim'

" auto-git-diff(rebase plugin)
Plug 'hotwatermorning/auto-git-diff'

" modesearch.vim
Plug 'monaqa/modesearch.vim'

" nvim-remote-containers
Plug 'jamestthompson3/nvim-remote-containers'

" bufjump.nvim
Plug 'kwkarlwang/bufjump.nvim'

" nvim-pasta
" Plug 'hrsh7th/nvim-pasta'

" vim-gh-line
Plug 'ruanyl/vim-gh-line'

" scratch.vim
Plug 'mtth/scratch.vim'

" latest no setting plugins
" Plug 'osyo-manga/vim-brightest'
Plug 'tyru/capture.vim'
Plug 'lambdalisue/readablefold.vim'
" Plug 'tpope/vim-speeddating'
Plug 'mtdl9/vim-log-highlighting'

" no setting file
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-surround'
" Plug 'airblade/vim-gitgutter'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-repeat'
Plug 'cohama/lexima.vim'
Plug 'alvan/vim-closetag', { 'for': ['html', 'vue', 'html.twig'] }
" Plug 'terryma/vim-multiple-cursors'
Plug 'machakann/vim-highlightedyank'
Plug 'emezeske/manpageview'
Plug 'markonm/traces.vim'
Plug 'mattn/vim-maketable'
Plug 'tyru/caw.vim'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'thinca/vim-quickrun'
Plug 'flazz/vim-colorschemes'
Plug 'tyru/open-browser.vim'
Plug 'tyru/open-browser-github.vim'
Plug 'junegunn/goyo.vim'
Plug 'AndrewRadev/linediff.vim'
Plug 'thinca/vim-poslist'
" Plug 'thinca/vim-visualstar'
Plug 'vim-scripts/autodate.vim'
Plug 'rhysd/clever-f.vim'
Plug 't9md/vim-choosewin'
Plug 'mbbill/undotree'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-jp/vital.vim'
Plug 'mattn/vim-sonictemplate'
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-test/vim-test'
Plug 'heavenshell/vim-jsdoc', {
  \ 'for': ['javascript', 'javascript.jsx','typescript'],
  \ 'do': 'make install'
\}
Plug 'mattn/emmet-vim'
Plug 'machakann/vim-sandwich'
Plug 'ap/vim-css-color'
Plug 'jsborjesson/vim-uppercase-sql'

" oj.vim
" Plug '~/go/src/github.com/my0k/vim-oj-helper'
Plug 'maguroguma/vim-oj-helper'

""""
" 引退したplugin
""""

" nerdtree
" Plug 'scrooloose/nerdtree'
" Plug 'jistr/vim-nerdtree-tabs'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'blueyed/vim-diminactive'
" Plug 'TaDaa/vimade'
" Plug 'myusuf3/numbers.vim'
" Plug 'bronson/vim-trailing-whitespace'
" Plug 'tpope/vim-eunuch'
" Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install', 'for': ['md', 'markdown'] }
" Plug 'Asheq/close-buffers.vim'
" ctrlp.init.vim
" Plug 'nixprime/cpsm', { 'do': 'env PY3=ON ./install.sh' }
" Plug 'ctrlpvim/ctrlp.vim'
" Plug '/usr/local/opt/fzf'
" Plug 'junegunn/fzf.vim'
" url-encode
" Plug 'koron/chalice'
" Plug 'ynkdir/vim-funlib'
" vim-toggle
" Plug 'taku-o/vim-toggle'
" Plug 'unblevable/quick-scope'
" expand-region
" Plug 'terryma/vim-expand-region'
" Plug 'kana/vim-operator-replace'
" Plug 'mhinz/vim-startify'
" Plug 'psliwka/vim-smoothie'
" Plug 'itchyny/vim-cursorword'
" Plug 'skywind3000/asyncrun.vim'
" Plug 'mcchrish/nnn.vim'
" Plug 'romainl/vim-cool'
" Plug 'osyo-manga/vim-anzu'
" Plug 'Shougo/neomru.vim'
" Plug 'Shougo/denite.nvim'
" Plug 'Shougo/neosnippet.vim'
" Plug 'Shougo/neosnippet-snippets'
" Plug 'tpope/vim-commentary'
" Plug 'wellle/context.vim'

call plug#end()
filetype plugin indent on

" leader
let mapleader="\<Space>"

" プラグイン設定ファイル読み込み
runtime ./statusline.init.vim
runtime ./markdown.init.vim
runtime ./golang.init.vim
runtime ./theme.init.vim
runtime ./buffer.init.vim
runtime ./coc.init.vim
runtime ./ctrlp.init.vim
runtime ./memolist.init.vim
runtime ./tempfile.init.vim
runtime ./alice.init.vim
runtime ./autodate.init.vim
runtime ./cleverf.init.vim
runtime ./choosewin.init.vim
runtime ./quickrun.init.vim
runtime ./undotree.init.vim
runtime ./command.init.vim
runtime ./grepper.init.vim
runtime ./winresizer.init.vim
runtime ./wildernvim.init.vim
runtime ./ultisnip.init.vim
runtime ./textobj.init.vim
runtime ./fern.init.vim
runtime ./defx.init.vim
runtime ./bookmarks.init.vim
" runtime ./treesitter.init.vim
runtime ./lir.init.vim
runtime ./motion.init.vim
" 自作コマンドなど
runtime ./original/general.init.vim
runtime ./original/competitive.init.vim
runtime ./original/todo.init.vim
runtime ./original/practical.init.vim
runtime ./original/terminal.init.vim
runtime ./original/shell-history.vim
" 手動donwloadしたもの
runtime ./downloads/catn.vim
runtime ./downloads/qargs.vim
runtime ./downloads/jq.vim

" 汎用設定ファイル読み込み（プラグインに上書きされないように最後に読む）
runtime ./set.init.vim
runtime ./map.init.vim
runtime ./basic.init.vim

" python3 path
" @os-dependency
" let g:python3_host_prog = expand('~/.pyenv/versions/neovim3/bin/python')
" let g:python3_host_prog = expand('/usr/local/bin/python3')
" let g:python3_host_prog = expand('/usr/bin/python3')
let g:python3_host_prog = expand('/opt/homebrew/bin/python3')

" function
"" xaml
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END
if !exists('*s:setupWrapping')
  function s:setupWrapping()
    set wrap
    set wm=2
    set textwidth=79
  endfunction
endif

"" make/cmake
augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

"" python
augroup vimrc-python
  autocmd!
  autocmd FileType python setlocal
      \ formatoptions+=croq softtabstop=4
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END


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

" vi互換モードで動作させない
set nocompatible

syntax enable

" 全モードでマウス利用
set mouse=n

" foldXXX
" インデントレベルで折り畳めるように
set foldmethod=indent
" 初期表示で折り畳まにように
set foldlevelstart=100

" 80文字ルール
" set colorcolumn=80
" execute "set colorcolumn=" . join(range(101, 9999), ',')



if has("autocmd")
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "ファイルタイプに合わせたインデントを利用
  filetype indent on
  "sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtabの略
  autocmd FileType c           setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType js          setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scala       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType json        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType css         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scss        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType sass        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript  setlocal sw=2 sts=2 ts=2 et
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 比較的最近知った設定
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 元いた場所に戻る
" nnoremap <C--> <C-o>
" 元いた場所に進む
" nnoremap ?? <C-i>

" 以前いたバッファに戻る
" nnoremap <C--> <C-^>

