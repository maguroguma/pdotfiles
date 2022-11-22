"""
" ENTRYPOINT:
"""

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
" common library
Plug 'vim-denops/denops.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'vim-jp/vital.vim'

" no setting
Plug 'vim-jp/vimdoc-ja'
Plug 'mzlogin/vim-markdown-toc', { 'for': ['md', 'markdown'] }
Plug 'iamcco/mathjax-support-for-mkdp', { 'for': ['md', 'markdown'] }
Plug 'simeji/winresizer'
Plug 'segeljakt/vim-silicon' " code snapshot tool helper
Plug 'rhysd/committia.vim'
Plug 'RRethy/vim-illuminate'
Plug 'tversteeg/registers.nvim'
Plug 'deton/jasegment.vim'
Plug 'hotwatermorning/auto-git-diff' " show git diff
Plug 'jamestthompson3/nvim-remote-containers'
Plug 'tyru/capture.vim' " read vim command result to buffer
Plug 'lambdalisue/readablefold.vim'
Plug 'mtdl9/vim-log-highlighting'
Plug 'Raimondi/delimitMate' " automatic closing of quotes, parenthesis, brackets, etc.
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-repeat'
Plug 'alvan/vim-closetag', { 'for': ['html', 'vue', 'html.twig'] }
Plug 'AndrewRadev/linediff.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'mattn/vim-sonictemplate'
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-test/vim-test'
Plug 'machakann/vim-sandwich'
Plug 'ap/vim-css-color'
Plug 'jsborjesson/vim-uppercase-sql'
Plug 'skanehira/denops-docker.vim'
Plug 'posva/vim-vue'
Plug 'tomtom/tcomment_vim' " for commenting on vue SFC
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'mattn/vim-sqlfmt'

" basic-setting.vim
Plug 'junegunn/vim-easy-align'
Plug 'mattn/emmet-vim', { 'for' : ['html', 'vue', 'html.twig'] }
Plug 'luochen1990/rainbow'
Plug 'ntpeters/vim-better-whitespace'
Plug 'sirver/ultisnips' " require coc-ultisnips if used with coc.nvim
Plug 'moll/vim-bbye'
Plug 'glidenote/memolist.vim'
Plug 'mhinz/vim-grepper'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'haya14busa/vim-asterisk' " better asterisk behavior
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } } " documentation tool
Plug 't9md/vim-quickhl' " mark colors to words and sentences
Plug 'windwp/nvim-spectre' " pretty good grep tool
Plug 'monaqa/dial.nvim' " better <C-a> and <C-x>
Plug 'tpope/vim-surround'
Plug 'machakann/vim-highlightedyank'
Plug 'markonm/traces.vim' " realize live substitute
Plug 'mattn/vim-maketable'
Plug 'tyru/caw.vim' " vim comment plugin
Plug 'thinca/vim-quickrun'
Plug 'tyru/open-browser.vim'
Plug 'tyru/open-browser-github.vim'
Plug 'junegunn/goyo.vim' " zen mode
Plug 'vim-scripts/autodate.vim' " add automatic updating date format
Plug 't9md/vim-choosewin'
Plug 'mbbill/undotree'
Plug 'heavenshell/vim-jsdoc', {
  \ 'for': ['javascript', 'javascript.jsx','typescript'],
  \ 'do': 'make install'
\}
Plug 'previm/previm' " markdown preview
Plug 'w0ng/vim-hybrid' " vim theme
Plug 'srcery-colors/srcery-vim' " vim theme
Plug 'tpope/vim-fugitive'
Plug 'kdheepak/lazygit.nvim'
Plug 'ruanyl/vim-gh-line'
Plug 'voldikss/vim-floaterm' " terminal by float window
Plug 'TaDaa/vimade'

" lua-setting.vim
Plug 'lewis6991/gitsigns.nvim'
Plug 'kevinhwang91/nvim-bqf'
Plug 'folke/todo-comments.nvim'
Plug 'kwkarlwang/bufjump.nvim'
Plug 'max397574/better-escape.nvim'

" statusline-setting.vim
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" golang-setting.vim
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' }
Plug 'jodosha/vim-godebug', { 'for': 'go' }

" coc-setting.vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'liuchengxu/vista.vim'

" fzf-setting.vim
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" lir-setting.vim
Plug 'tamago324/lir.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'tamago324/lir-git-status.nvim'

" textobj-setting.vim
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-jabraces'
Plug 'osyo-manga/vim-textobj-multiblock'
Plug 'osyo-manga/vim-textobj-multitextobj'

" motion-setting.vim
Plug 'rlane/pounce.nvim'
Plug 'yuki-yano/fuzzy-motion.vim'

" lexima-setting.vim
Plug 'cohama/lexima.vim'

Plug 'maguroguma/vim-oj-helper'

" wildernvim-setting.vim
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
call plug#end()

filetype plugin indent on

" leaderの設定は最初に行う
let mapleader="\<Space>"

" python3 path
let g:python3_host_prog = expand('$VIM_PYTHON_PATH')

" プラグイン設定ファイル読み込み
runtime ./plugins/statusline-setting.vim
runtime ./plugins/golang-setting.vim
runtime ./plugins/fzf-setting.vim
runtime ./plugins/textobj-setting.vim
runtime ./plugins/lir-setting.vim
runtime ./plugins/wildernvim-setting.vim
runtime ./plugins/basic-setting.vim
runtime ./plugins/lua-setting.vim
runtime ./plugins/motion-setting.vim
runtime ./plugins/lexima-setting.vim
runtime ./plugins/coc-setting.vim
" 手動donwloadしたもの
runtime ./downloads/catn.vim
runtime ./downloads/qargs.vim
runtime ./downloads/jq.vim
" 自作コマンドなど
runtime ./original/general.init.vim
runtime ./original/competitive.init.vim
runtime ./original/todo.init.vim
runtime ./original/practical.init.vim
runtime ./original/shell-history.vim
runtime ./original/nkf.vim
runtime ./original/trim-trailing-whitespaces.vim
runtime ./original/search-pr-by-commit.vim
runtime ./original/trans.vim

" 汎用設定ファイル読み込み（プラグインに上書きされないように最後に読む）
runtime ./set.init.vim
runtime ./map.init.vim
