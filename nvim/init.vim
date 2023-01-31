if exists('g:loaded_maguroguma_nvim_setting')
  finish
endif
let g:loaded_maguroguma_nvim_setting = 1

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
let g:loaded_matchparen         = v:true
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

" main version
let s:main_jetpack_dir = stdpath('data') .. '/site/pack/jetpack/main/'

" load hook post sources
execute 'source ' .. expand('$XDG_CONFIG_HOME/nvim/lazysource.vim')

" manage plugins by jetpack
" plugins {{{
packadd vim-jetpack
call jetpack#begin(s:main_jetpack_dir)
call jetpack#add('tani/vim-jetpack', { 'opt': 1 })

" common library
call jetpack#add('vim-denops/denops.vim')
call jetpack#add('nvim-lua/plenary.nvim')
call jetpack#add('Shougo/vimproc.vim', { 'build' : 'make' })
call jetpack#add('vim-jp/vital.vim')

call jetpack#add('vim-jp/vimdoc-ja')
call jetpack#add('ryanoasis/vim-devicons')
call jetpack#add('editorconfig/editorconfig-vim')
call jetpack#add('vim-scripts/autodate.vim') " add automatic updating date format
call jetpack#add('w0ng/vim-hybrid') " vim theme

" DO NOT lazy load
call jetpack#add('lambdalisue/readablefold.vim')
call jetpack#add('Yggdroot/indentLine')
call jetpack#add('machakann/vim-sandwich')
call jetpack#add('luochen1990/rainbow')
call jetpack#add('ruanyl/vim-gh-line')
call jetpack#add('segeljakt/vim-silicon') " code snapshot tool helper
call jetpack#add('mattn/vim-sonictemplate')
call jetpack#add('thinca/vim-partedit')
call jetpack#add('previm/previm')
call jetpack#add('kana/vim-textobj-user')

" depends on denops
call jetpack#add('lambdalisue/butler.vim') " ChatGPT wrapper
call jetpack#add('lambdalisue/kensaku.vim') " search Japanese by megemo
call jetpack#add('lambdalisue/kensaku-search.vim')
call jetpack#add('lambdalisue/kensaku-command.vim')
call jetpack#add('yuki-yano/fuzzy-motion.vim') " pounce like motion plugin

" lua plugin
call jetpack#add('kevinhwang91/nvim-bqf')
call jetpack#add('nvim-lualine/lualine.nvim')

" lazy
call jetpack#add('tpope/vim-fugitive', {
      \ 'on_cmd': ['Git', 'GCheckoutThis'],
      \ 'hook_post_source': g:jetpack_fugitive_scripts
      \ })
call jetpack#add('glidenote/memolist.vim', {
      \ 'on_cmd': ['MemoNew', 'MemoList', 'MemoGrep'],
      \ 'hook_post_source': g:jetpack_memolist_scripts
      \ })
call jetpack#add('lewis6991/gitsigns.nvim', {
      \ 'on_cmd': ['NvimTreeToggle', 'NvimTreeOpen', 'Files'],
      \ 'hook_post_source': g:jetpack_gitsigns_scripts
      \ })
call jetpack#add('hrsh7th/nvim-cmp', {
      \ 'on_event': 'CmdlineEnter'
      \ })
call jetpack#add('hrsh7th/cmp-buffer', {
      \ 'on_event': 'CmdlineEnter',
      \ 'depends': 'hrsh7th/nvim-cmp'
      \ })
call jetpack#add('hrsh7th/cmp-path', {
      \ 'on_event': 'CmdlineEnter',
      \ 'depends': 'hrsh7th/nvim-cmp'
      \ })
call jetpack#add('hrsh7th/cmp-cmdline', {
      \ 'on_event': 'CmdlineEnter',
      \ 'depends': 'hrsh7th/nvim-cmp',
      \ 'hook_post_source': g:jetpack_cmp_scripts
      \ })
call jetpack#add('nvim-tree/nvim-web-devicons', {
      \ 'on_cmd': ['NvimTreeToggle', 'NvimTreeOpen']
      \ })
call jetpack#add('nvim-tree/nvim-tree.lua', {
      \ 'on_cmd': ['NvimTreeToggle', 'NvimTreeOpen'],
      \ 'depends': 'nvim-tree/nvim-web-devicons',
      \ 'hook_post_source': g:jetpack_nvim_tree_scripts
      \ })
call jetpack#add('mbbill/undotree', {
      \ 'on_cmd': ['UndotreeToggle'],
      \ 'hook_post_source': g:jetpack_undotree_scripts
      \ })
call jetpack#add('voldikss/vim-floaterm', {
      \ 'on_cmd': ['FloatermToggle'],
      \ 'hook_post_source': g:jetpack_floaterm_scripts
      \ })
call jetpack#add('fatih/vim-go', {
      \ 'on_ft': 'go',
      \ 'hook_post_source': g:jetpack_vim_go_scripts
      \ })
" better <C-a> and <C-x>
call jetpack#add('monaqa/dial.nvim', {
      \ 'on_cmd': ['DialIncrement', 'DialDecrement'],
      \ 'hook_post_source': g:jetpack_dial_scripts
      \ })
call jetpack#add('lambdalisue/fern.vim', {
      \ 'on_cmd': 'Fern',
      \ 'hook_post_source': g:jetpack_fern_scripts
      \ })
call jetpack#add('lambdalisue/fern-git-status.vim', {
      \ 'on_cmd': 'Fern',
      \ 'depends': 'lambdalisue/fern.vim'
      \ })
call jetpack#add('lambdalisue/nerdfont.vim', {
      \ 'on_cmd': 'Fern',
      \ 'depends': 'lambdalisue/fern.vim'
      \ })
call jetpack#add('lambdalisue/fern-renderer-nerdfont.vim', {
      \ 'on_cmd': 'Fern',
      \ 'depends': 'lambdalisue/fern.vim'
      \ })
call jetpack#add('lambdalisue/glyph-palette.vim', {
      \ 'on_cmd': 'Fern',
      \ 'depends': 'lambdalisue/fern.vim'
      \ })
call jetpack#add('lambdalisue/fern-hijack.vim', {
      \ 'on_cmd': 'Fern',
      \ 'depends': 'lambdalisue/fern.vim'
      \ })
call jetpack#add('junegunn/fzf', {
      \ 'on_cmd': ['Files', 'HCommand', 'Buffers', 'MemoList']
      \ })
call jetpack#add('junegunn/fzf.vim', {
      \ 'depends': 'junegunn/fzf',
      \ 'on_cmd': ['Files', 'HCommand', 'Buffers', 'MemoList'],
      \ 'hook_post_source': g:jetpack_fzf_scripts
      \ })
call jetpack#add('rlane/pounce.nvim', {
      \ 'on_cmd': ['Pounce'],
      \ 'hook_post_source': g:jetpack_pounce_scripts
      \ })
call jetpack#add('folke/todo-comments.nvim', {
      \ 'on_cmd': ['NvimTreeToggle', 'NvimTreeOpen', 'Files'],
      \ 'hook_post_source': g:jetpack_todo_comments_scripts
      \ })
call jetpack#add('stevearc/aerial.nvim', {
      \ 'depends': 'nvim-tree/nvim-web-devicons',
      \ 'on_cmd': ['AerialToggle'],
      \ 'hook_post_source': g:jetpack_aerial_scripts
      \ })
call jetpack#add('max397574/better-escape.nvim', {
      \ 'on_event': 'InsertEnter',
      \ 'hook_post_source': g:jetpack_better_escape_scripts
      \ })
call jetpack#add('nvim-treesitter/nvim-treesitter', {
      \ 'on_cmd': ['NvimTreeToggle', 'NvimTreeOpen', 'Files'],
      \ 'hook_post_source': g:jetpack_treesitter_scripts
      \ })
call jetpack#add('rhysd/committia.vim', {
      \ 'on_ft': ['gitcommit', 'git'],
      \ 'hook_post_source': g:jetpack_committia_scripts
      \ })
call jetpack#add('neoclide/coc.nvim', {
      \ 'branch': 'release',
      \ 'on_cmd': ['NvimTreeToggle', 'NvimTreeOpen', 'Files'],
      \ 'hook_post_source': g:jetpack_coc_scripts
      \ })
call jetpack#add('cohama/lexima.vim', {
      \ 'depends': 'neoclide/coc.nvim',
      \ 'on_event': 'InsertEnter',
      \ 'hook_post_source': g:jetpack_lexima_scripts
      \ })
" better asterisk behavior
call jetpack#add('haya14busa/vim-asterisk', {
      \ 'on_map': '<Plug>(asterisk',
      \ 'on_event': 'CmdlineEnter'
      \ })
call jetpack#add('kevinhwang91/nvim-hlslens', {
      \ 'depends': 'haya14busa/vim-asterisk',
      \ 'on_map': '<Plug>(asterisk',
      \ 'on_event': 'CmdlineEnter',
      \ 'hook_post_source': g:jetpack_hlslens_scripts
      \ })
call jetpack#add('mattn/emmet-vim', {
      \ 'on_ft': ['html', 'vue', 'html.twig'],
      \ 'hook_post_source': g:jetpack_emmet_scripts
      \ })
call jetpack#add('heavenshell/vim-jsdoc', {
      \ 'on_ft': ['javascript', 'javascript.jsx','typescript'],
      \ 'build': 'make install',
      \ 'hook_post_source': g:jetpack_jsdoc_scripts
      \ })
call jetpack#add('t9md/vim-choosewin', {
      \ 'on_cmd': 'ChooseWin',
      \ 'hook_post_source': g:jetpack_choosewin_scripts
      \ })
call jetpack#add('MattesGroeger/vim-bookmarks', {
      \ 'on_cmd': ['BookmarkToggle', 'BookmarkAnnotate', 'BookmarkShowAll', 'BookmarkClear', 'BookmarkClearAll', 'BookmarkMoveUp', 'BookmarkMoveDown', 'BookmarkMoveToLine'],
      \ 'hook_post_source': g:jetpack_bookmarks_scripts
      \ })
call jetpack#add('ntpeters/vim-better-whitespace', {
      \ 'on_event': ['CursorHold', 'CursorMoved'],
      \ 'hook_post_source': g:jetpack_better_whitespace_scripts
      \ })
call jetpack#add('machakann/vim-highlightedyank', {
      \ 'on_event': ['CursorHold', 'CursorMoved'],
      \ 'hook_post_source': g:jetpack_highlightedyank_scripts
      \ })
call jetpack#add('kyoh86/vim-ripgrep', {
      \ 'on_cmd': 'Ripgrep',
      \ 'hook_post_source': g:jetpack_ripgrep_scripts
      \ })
" read vim command result to buffer
call jetpack#add('tyru/capture.vim', {
      \ 'on_cmd': ['Capture']
      \ })
call jetpack#add('AndrewRadev/linediff.vim', {
      \ 'on_cmd': ['Linediff']
      \ })
call jetpack#add('moll/vim-bbye', {
      \ 'on_cmd': ['Bdelete']
      \ })
call jetpack#add('mattn/vim-maketable', {
      \ 'on_ft': ['md', 'markdown']
      \ })
call jetpack#add('jodosha/vim-godebug', {
      \ 'on_ft': 'go'
      \ })
" automatic closing of quotes, parenthesis, brackets, etc.
call jetpack#add('Raimondi/delimitMate', {
      \ 'on_event': 'InsertEnter'
      \ })
call jetpack#add('windwp/nvim-spectre', {
      \ 'on_cmd': 'Spectre'
      \ })
call jetpack#add('simeji/winresizer', {
      \ 'on_cmd': 'WinResizerStartResize'
      \ })
" for commenting on vue SFC
call jetpack#add('tomtom/tcomment_vim', {
      \ 'on_event': ['CursorHold', 'CursorMoved']
      \ })
call jetpack#add('vim-test/vim-test', {
      \ 'on_cmd': ['TestFile', 'TestNearest']
      \ })
" mark colors to words and sentences
call jetpack#add('t9md/vim-quickhl', {
      \ 'on_map': '<Plug>(quickhl'
      \ })
" realize live substitute
call jetpack#add('markonm/traces.vim', {
      \ 'on_event': 'CmdlineEnter'
      \ })
call jetpack#add('tyru/open-browser.vim', {
      \ 'on_map': '<Plug>(openbrowser-smart-search)'
      \ })
call jetpack#add('monaqa/modesearch.vim', {
      \ 'on_map': '<Plug>(modesearch-'
      \ })
" require coc-ultisnips if used with coc.nvim
call jetpack#add('sirver/ultisnips', {
      \ 'on_event': 'InsertEnter'
      \ })
call jetpack#add('mtdl9/vim-log-highlighting', {
      \ 'on_ft': ['log']
      \ })
" show git diff on git rebase
call jetpack#add('hotwatermorning/auto-git-diff', {
      \ 'on_ft': ['gitcommit', 'git']
      \ })
call jetpack#add('mzlogin/vim-markdown-toc', {
      \ 'on_ft': ['md', 'markdown']
      \ })
call jetpack#add('iamcco/mathjax-support-for-mkdp', {
      \ 'on_ft': ['md', 'markdown']
      \ })
call jetpack#add('alvan/vim-closetag', {
      \ 'on_ft': ['html', 'vue', 'html.twig']
      \ })
call jetpack#add('ap/vim-css-color', {
      \ 'on_ft': ['html', 'vue', 'html.twig']
      \ })
call jetpack#add('jsborjesson/vim-uppercase-sql', {
      \ 'on_ft': ['sql']
      \ })
call jetpack#add('posva/vim-vue', {
      \ 'on_ft': ['vue']
      \ })
call jetpack#add('mattn/vim-sqlfmt', {
      \ 'on_ft': ['sql']
      \ })
call jetpack#end()
" plugins END }}}

" Automatic plugin installation on startup
for name in jetpack#names()
  if !jetpack#tap(name)
    call jetpack#sync()
    break
  endif
endfor

" this settings need to be loaded first.
filetype plugin indent on
let mapleader = "\<Space>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SECTION: plugin map
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Snippets, Commits, BCommits, Commands
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> R :HCommand<CR>
nnoremap <silent> ; :Buffers<CR>

nmap <Space><tab> <plug>(fzf-maps-n)
xmap <Space><tab> <plug>(fzf-maps-x)
omap <Space><tab> <plug>(fzf-maps-o)
imap <C-a><tab> <plug>(fzf-maps-i)

nmap <silent> <C-f> <cmd>NvimTreeToggle<CR>
nmap <silent> f <cmd>NvimTreeOpen .<CR>
nmap <silent> <C-h> <cmd>execute 'NvimTreeOpen ' . expand('%:p:h')<CR>

nnoremap <silent> <Space>gc :GCheckoutThis<CR>
nnoremap <Space>gd :Git diff %<CR>
nnoremap <Space>gb :Git blame<CR>
nnoremap <Space>ga :Git add %<CR>
nnoremap <silent> <Space>gl :Git log %<CR>

let g:sonictemplate_vim_template_dir = [
      \ expand('$GOPATH/src/github.com/maguroguma/go-competitive/template'),
      \ expand('$DOTFILES_DIR/nvim/sonic-template'),
      \]

let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)

nmap M <Plug>(quickhl-manual-this)
xmap M <Plug>(quickhl-manual-this)

nnoremap <Space>s <cmd>Spectre<CR>

nmap  <C-a>  <cmd>DialIncrement<CR>
nmap  <C-x>  <cmd>DialDecrement<CR>

let g:gh_line_map_default = 0
let g:gh_line_blame_map_default = 0
let g:gh_line_map = '<Space>gh'

let autodate_format="%Y-%m-%d %H:%M:%S"
inoremap <C-a>lc Last Change: 2022-08-14 17:06:15.

nmap <Space>mm <cmd>BookmarkToggle<CR>
nmap <Space>mi <cmd>BookmarkAnnotate<CR>
nmap <Space>ma <cmd>BookmarkShowAll<CR>
nmap <Space>mc <cmd>BookmarkClear<CR>
nmap <Space>mx <cmd>BookmarkClearAll<CR>
nmap <Space>mkk <cmd>BookmarkMoveUp<CR>
nmap <Space>mjj <cmd>BookmarkMoveDown<CR>
nmap <Space>mg <cmd>BookmarkMoveToLine<CR>
" require coc-fzf-preview
nnoremap <Space>mf <cmd>CocCommand fzf-preview.Bookmarks<CR>

nnoremap <Space>d <C-u>:Bdelete<CR>
nnoremap <Space>D <C-u>:bufdo :Bdelete<CR>

nmap ss <cmd>ChooseWin<CR>

nnoremap <Space>mn  :MemoNew<CR>
nnoremap <Space>ml  :MemoList<CR>
nnoremap <Space>mg  :MemoGrep<CR>

set background=dark
colorscheme hybrid

noremap <Space>u :UndotreeToggle<CR>

nnoremap <C-s> <Cmd>FloatermToggle<CR>

nmap g/ <Plug>(modesearch-slash)
nmap g? <Plug>(modesearch-question)
cmap <C-x> <Plug>(modesearch-toggle-mode)

let g:partedit#auto_prefix = v:false

nmap <C-e> <cmd>WinResizerStartResize<CR>

let g:previm_open_cmd = 'open -a Google\ Chrome'
nnoremap <silent> <Space>mp <cmd>PrevimOpen<CR>

let g:UltiSnipsExpandTrigger = '<c-j>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:UltiSnipsEditSplit = 'vertical'
" let g:UltiSnipsSnippetDirectories = ['']

" kana/vim-textobj-user setting
call textobj#user#plugin('datetime', {
\   'date': {
\     'pattern': '\<\d\d\d\d-\d\d-\d\d\>',
\     'select': ['ad', 'id'],
\   },
\   'time': {
\     'pattern': '\<\d\d:\d\d:\d\d\>',
\     'select': ['at', 'it'],
\   },
\ })

call textobj#user#plugin('braces', {
\   'angle': {
\     'pattern': ['<<', '>>'],
\     'select-a': 'aA',
\     'select-i': 'iA',
\   },
\ })

" japanese brackets
call textobj#user#plugin('jparentheses', {
\   'jparentheses': {
\     'pattern': ['（', '）'],
\     'select-a': 'aj(',
\     'select-i': 'ij(',
\   },
\ })
call textobj#user#plugin('jsquarebrackets', {
\   'jsquarebrackets': {
\     'pattern': ['【', '】'],
\     'select-a': 'aj[',
\     'select-i': 'ij[',
\   },
\ })
call textobj#user#plugin('jquotation', {
\   'jquotation': {
\     'pattern': ['「', '」'],
\     'select-a': 'ajb',
\     'select-i': 'ijb',
\   },
\ })

call textobj#user#plugin('line', {
\   '-': {
\     'select-a-function': 'CurrentLineA',
\     'select-a': 'al',
\     'select-i-function': 'CurrentLineI',
\     'select-i': 'il',
\   },
\ })

function! CurrentLineA()
  normal! 0
  let head_pos = getpos('.')
  normal! $
  let tail_pos = getpos('.')
  return ['v', head_pos, tail_pos]
endfunction

function! CurrentLineI()
  normal! ^
  let head_pos = getpos('.')
  normal! g_
  let tail_pos = getpos('.')
  let non_blank_char_exists_p = getline('.')[head_pos[2] - 1] !~# '\s'
  return
  \ non_blank_char_exists_p
  \ ? ['v', head_pos, tail_pos]
  \ : 0
endfunction

let g:fuzzy_motion_labels = [
      \ 'H', 'J', 'K', 'L', 'Y',
      \ 'U', 'I', 'O', 'P', 'N',
      \ 'M', 'Q', 'W', 'E', 'R',
      \ 'T', 'A', 'S', 'D', 'F',
      \ 'G', 'Z', 'X', 'C', 'V',
      \ 'B'
      \]
highlight FuzzyMotionMatch ctermfg=159 ctermbg=240
highlight FuzzyMotionChar cterm=bold ctermfg=207
highlight FuzzyMotionSubChar cterm=bold ctermfg=44
" highlight FuzzyMotionShade ctermfg=0 ctermbg=0
let g:fuzzy_motion_matchers = ['fzf', 'kensaku']
cnoremap <C-a><CR> <Plug>(kensaku-search-replace)<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SECTION: original
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 引用元: http://koturn.hatenablog.com/entry/2015/07/27/042519
if executable('jq')
  function! s:jq(has_bang, ...) abort range
    execute 'silent' a:firstline ',' a:lastline '!jq' string(a:0 == 0 ? '.' : a:1)
    if !v:shell_error || a:has_bang
      return
    endif
    let error_lines = filter(getline('1', '$'), 'v:val =~# "^parse error: "')
    " 範囲指定している場合のために，行番号を置き換える
    let error_lines = map(error_lines, 'substitute(v:val, "line \\zs\\(\\d\\+\\)\\ze,", "\\=(submatch(1) + a:firstline - 1)", "")')
    let winheight = len(error_lines) > 10 ? 10 : len(error_lines)
    " カレントバッファがエラーメッセージになっているので，元に戻す
    undo
    " カレントバッファの下に新たにウィンドウを作り，エラーメッセージを表示するバッファを作成する
    execute 'botright' winheight 'new'
    setlocal nobuflisted bufhidden=unload buftype=nofile
    call setline(1, error_lines)
    " エラーメッセージ用バッファのundo履歴を削除(エラーメッセージをundoで消去しないため)
    let save_undolevels = &l:undolevels
    setlocal undolevels=-1
    execute "normal! a \<BS>\<Esc>"
    setlocal nomodified
    let &l:undolevels = save_undolevels
    " エラーメッセージ用バッファは読み取り専用にしておく
    setlocal readonly
  endfunction

  command! -bar -bang -range=% -nargs=? Jq  <line1>,<line2>call s:jq(<bang>0, <f-args>)
endif

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

" markdownのコードスニペット
function! g:ReadTripleBackQuotes(lang_text)
  let l:text = "```" . a:lang_text . "\n```"
  let tmp = @a
  let @a = l:text
  execute 'normal "ap'
  let @a = tmp
endfunction
command! -nargs=1 TripleBackQuotes :call g:ReadTripleBackQuotes(<f-args>)
nnoremap <Space>` :call g:ReadTripleBackQuotes("")<CR>

" ファイル・バッファのエンコーディング
command! OpenAsSjis :edit ++encoding=sjis<CR>
command! OpenAsUtf8 :e ++enc=utf-8<CR>
command! SaveAsSjis :set fileencoding=cp932<CR>
command! SaveAsUtf8 :se fenc=utf-8<CR>
command! WhatCurEncoding :se enc?
command! WhatCurFEncoding :se fenc?

" タイムスタンプ・日時の相互変換
" JST日時 -> タイムスタンプ: date -j -f "%Y/%m/%d %T" "2019/03/16 11:18:00" "+%s"
" タイムスタンプ -> JST日時: date -j -f "%s" "1552735080" "+%Y/%m/%d %T"

" %:hのための、:hのマッピング
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" 一時ファイルを作成して開くコマンド
command! OpenTempfile :edit `=tempname()`

" 自動的にディレクトリを作成する: https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
augroup vimrc-auto-mkdir  " {{{
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)  " {{{
    if !isdirectory(a:dir) && (a:force ||
    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction  " }}}
augroup END  " }}}

" terminal modeにおけるnormal modeへの移行
tnoremap <C-e> <C-\><C-n>

" 参考: https://github.com/uga-rosa/dotfiles/blob/main/.config/nvim/plugin/term.vim
let s:termname = "nvim_terminal"
function! TermToggle() abort
    let l:pane = bufwinnr(s:termname)
    let l:buf = bufexists(s:termname)
    if pane > 0
        execute pane . "wincmd c"
    elseif buf > 0
        botright vs
        execute "buffer " . s:termname
        startinsert
    else
        botright vs
        terminal
        startinsert
        execute "f " . s:termname
        setlocal nobuflisted
    endif
endfunction

nnoremap <C-q> <cmd>call TermToggle()<cr>
tnoremap <C-q> <cmd>call TermToggle()<cr>

" ビジュアルモードで選択した内容を、シェルコマンドとして実行する（bレジスタを汚す）
xnoremap <Space>! "by:let res = "Execute: " .@b . "\n"<CR>:let res = res . system(@b)<CR>:echo res<CR>

" vim-jp
" ビジュアルモードで選択中の文字列を特定のコマンドに渡す
xnoremap <Space>e <Esc>gv"zy:<C-u>echo "<C-r>z"

" FIXME: sedのエラーを回避したい（Vim scriptで全部やるべき）
" show zsh command history
if getftype(expand('$HISTFILE')) != ""
  function! s:showShellHistory(...)
    execute 'botright' 10 'new'
    setlocal nobuflisted bufhidden=unload buftype=nofile
    silent read !cat $HISTFILE | cut -b 16- | head -n 5000
    " silent read !cat $HISTFILE |
    "       \ grep '^:' |
    "       \ cut -b 3-12 -b 16- |
    "       \ sed -r '2,$s/([0-9]{10})/\1@@@/' |
    "       \ awk -F '@@@' '/[0-9]{10}/ { printf("\%s; \%s\n", strftime("\%Y-\%m-\%d \%H:\%M:\%S", $1), $2) }' |
    "       \ head -n 5000
    if a:0 == 1
      let l:exe_com = 'v/' . a:1 . '/d'
      execute l:exe_com
    endif
    norm G
    setlocal nomodified
  endfunction

  " filter by strings given by the argument
  command! -nargs=? ShellHistory :call s:showShellHistory(<f-args>)
endif

" nkfコマンドが実行可能な場合
" 行Visualで指定した範囲に対して `nkf -Z0` （全角英数字・記号→半角に変換）を行う
if executable('nkf')
  function! s:nkf(has_bang, ...) abort range
    execute 'silent' a:firstline ',' a:lastline '!nkf -Z0'
  endfunction

  command! -bar -bang -range=% -nargs=? Nkf  <line1>,<line2>call s:nkf(<bang>0, <f-args>)
endif

command! -nargs=? TrimWhiteSpaces :%s/\s\+$//g

function! s:buildGitHubPRSearchURL(...)
  " GitHub PR search link
  " FIXME: カバーできていないケースが多そう（ghq -pで取得したリポジトリだと上手く行かない）
  let l:shell_one_liner = 'git remote -v | '
        \ . 'grep "github" | '
        \ . 'cut -d":" -f2 | '
        \ . 'cut -d"." -f1 | '
        \ . 'sort | uniq | '
        \ . 'awk ''{ printf "https://github.com/%s/pulls?q=is:pr is:closed ", $1 }'''
  let l:command_result = system(l:shell_one_liner)

  " word on the cursor
  let l:temp = @z
  norm "zyiw
  let l:search_word = @z
  let @z = l:temp

  " build query URL and assign it to the default and clipboard registers
  let l:goal = l:command_result . l:search_word
  let @" = l:goal
  let @+ = l:goal

  " interactive question whether open it by your default browser
  let l:confirm_msg = 'Open it by browser? -> ' . '"' . l:goal . '"'
  let l:is_open_browser = confirm(l:confirm_msg, "y yes\nn no")
  if l:is_open_browser != 1
    return
  endif
  if executable('open')
    let l:open_command = 'open ' . "'" . l:goal . "'"
    call system(l:open_command)
  elseif executable('xdg-open')
    let l:open_command = 'xdg-open ' . "'" . l:goal . "'"
    call system(l:open_command)
  else
    echo 'failed to open'
  endif
endfunction
command! -nargs=? GitHubPRSearchURL :call s:buildGitHubPRSearchURL(<f-args>)

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

" vimgrep
" vim grepすると自動的にあたらしいウィンドウで検索結果一覧を表示する
autocmd QuickFixCmdPost *grep* cwindow

" ripgrep with vim
" http://hogeai.hatenablog.com/entry/2018/03/04/201744
if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" :grepのショートカット
function! s:grep_cur_dir()
  let l:regexp = input("grep(rg) pattern: ")
  if l:regexp == ""
    echo "grep canceled."
    return
  endif
  let l:command = 'grep ' . l:regexp
  execute 'silent ' .. l:command
  if len(getqflist()) == 0
    echoerr 'not found: ' . l:command
  endif
endfunction
command! -nargs=0 MyVimGrep :call s:grep_cur_dir()
nnoremap <Space>gr <cmd>MyVimGrep<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SECTION: set options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

" 独自定義highlight
highlight CursorLine ctermbg=238
highlight Visual cterm=bold ctermbg=darkblue ctermfg=NONE
" highlight StatusLine cterm=bold ctermbg=193 ctermfg=0
" highlight StatusLineNC ctermbg=193
highlight NonText    ctermbg=None ctermfg=239 guibg=NONE guifg=None
highlight SpecialKey ctermbg=None ctermfg=239 guibg=NONE guifg=None
highlight Folded ctermbg=Green ctermfg=Gray
highlight Search ctermbg=44 ctermfg=0
highlight IncSearch cterm=bold ctermbg=44 ctermfg=0

" nvim-cmp
highlight! CmpItemAbbrMatch cterm=bold ctermbg=NONE ctermfg=44
highlight! CmpItemAbbrMatchFuzzy ctermbg=NONE ctermfg=27

" txtファイルで自動改行を防ぐ
" https://loumo.jp/archives/10503
autocmd FileType text :set formatoptions=q

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

execute 'set shell=' .. expand('$SHELL')
set title
set wildmenu
set history=200
set helplang=ja

set hidden

" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-min-max-lines
  autocmd!
  autocmd BufEnter * :syntax sync minlines=500 maxlines=1000
augroup END

" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" make/cmake
augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

" python
augroup vimrc-python
  autocmd!
  autocmd FileType python setlocal
      \ formatoptions+=croq softtabstop=4
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

if has("autocmd")
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
" inoremap <silent> jj <ESC> " better-escapeプラグインに委譲

" prefix
nnoremap s <Nop>
nnoremap t <Nop>
" nnoremap q <Nop>
nnoremap <Space> <Nop>

" command line window
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
" nnoremap <C-h> ^
" vnoremap <C-h> ^
nnoremap <C-l> $
vnoremap <C-l> $

" search
" nnoremap n nzz
" nnoremap N Nzz
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
nnoremap x "_x
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

augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

" :Profileコマンド実行後、そのあとに実行される関数、あるいは読み込まれるスクリプトファイルを対象に、
" ~/profile.txtにプロファイル情報を書き出す
" ref: https://zenn.dev/kato_k/articles/vim-tips-no004
command! Profile call s:command_profile()
function! s:command_profile() abort
  profile start ~/profile.txt
  profile func *
  profile file *
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lua scripts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set completeopt=menu,menuone,noselect
set pumheight=20

nmap <Space>v <cmd>AerialToggle<CR>

" jetpack利用時は先頭に追加するようにする
execute 'set runtimepath^=' .. expand('$XDG_DATA_HOME/nvim/site/pack/jetpack/nvim-treesitter')

"""
" PLUGSETTING: rlane/pounce.nvim
"""
" nmap ' <cmd>Pounce<CR>
nmap ' <cmd>FuzzyMotion<CR>
vmap ' <cmd>Pounce<CR>
omap g' <cmd>Pounce<CR>

lua << EOF
-- PLUGSETTING: kevinhwang91/nvim-bqf
local fn = vim.fn

function _G.qftf(info)
    local items
    local ret = {}
    if info.quickfix == 1 then
        items = fn.getqflist({id = info.id, items = 0}).items
    else
        items = fn.getloclist(info.winid, {id = info.id, items = 0}).items
    end
    local limit = 31
    local fname_fmt1, fname_fmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
    local valid_fmt = '%s │%5d:%-3d│%s %s'
    for i = info.start_idx, info.end_idx do
        local e = items[i]
        local fname = ''
        local str
        if e.valid == 1 then
            if e.bufnr > 0 then
                fname = fn.bufname(e.bufnr)
                if fname == '' then
                    fname = '[No Name]'
                else
                    fname = fname:gsub('^' .. vim.env.HOME, '~')
                end
                -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
                if #fname <= limit then
                    fname = fname_fmt1:format(fname)
                else
                    fname = fname_fmt2:format(fname:sub(1 - limit))
                end
            end
            local lnum = e.lnum > 99999 and -1 or e.lnum
            local col = e.col > 999 and -1 or e.col
            local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
            str = valid_fmt:format(fname, lnum, col, qtype, e.text)
        else
            str = e.text
        end
        table.insert(ret, str)
    end
    return ret
end

vim.o.qftf = '{info -> v:lua._G.qftf(info)}'

-- Adapt fzf's delimiter in nvim-bqf
vim.cmd([[
    hi BqfPreviewBorder guifg=#50a14f ctermfg=71
    hi link BqfPreviewRange Search
]])

require('bqf').setup({
    auto_enable = true,
    auto_resize_height = true, -- highly recommended enable
    preview = {
        win_height = 30,
        win_vheight = 30,
        delay_syntax = 80,
        border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'},
        should_preview_cb = function(bufnr)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 100 * 1024 then
                -- skip file size greater than 100k
                ret = false
            elseif bufname:match('^fugitive://') then
                -- skip fugitive buffer
                ret = false
            end
            return ret
        end
    },
    -- make `drop` and `tab drop` to become preferred
    func_map = {
        drop = 'o',
        openc = 'O',
        split = '<C-s>',
        tabdrop = '<C-t>',
        tabc = '',
        ptogglemode = 'z,',
    },
    filter = {
        fzf = {
            action_for = {['ctrl-s'] = 'split', ['ctrl-t'] = 'tab drop'},
            extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
        }
    }
})

require('lualine').setup {
  options = {
    section_separators = '', component_separators = '',
    theme = 'dracula',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'location'},
    lualine_c = {
      {
        'filename',
        path = 1,
        shorting_target = 40,
        newfile_status = true,   -- Display new file status (new file means no write after created)
        symbols = {
          modified = '[+]',      -- Text to show when the file is modified.
          readonly = '[-RO]',      -- Text to show when the file is non-modifiable or readonly.
          unnamed = '[No Name]', -- Text to show for unnamed buffers.
          newfile = '[New]',     -- Text to show for new created file before first writting
        },
      },
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'branch'},
    lualine_z = {}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        path = 1,
        shorting_target = 40,
      },
    },
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
}
EOF
