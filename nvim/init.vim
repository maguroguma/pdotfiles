if exists('g:loaded_maguroguma_nvim_setting')
  finish
endif
let g:loaded_maguroguma_nvim_setting = 1

" copilot.vim setting
let s:copilot_setting_file = expand('$XDG_CONFIG_HOME/nvim/copilot-setting.vim')
if filereadable(s:copilot_setting_file)
  execute 'source ' . s:copilot_setting_file
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SECTION: depeding on environment
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

execute 'set shell=' .. expand('$SHELL')

" jetpack利用時は先頭に追加するようにする
execute 'set runtimepath^=' .. expand('$XDG_DATA_HOME/nvim/site/pack/jetpack/nvim-treesitter')

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

" main version
let s:main_jetpack_dir = stdpath('data') .. '/site/pack/jetpack/main/'

" manage plugins by jetpack
" plugins {{{
packadd vim-jetpack
call jetpack#begin(s:main_jetpack_dir)
call jetpack#add('tani/vim-jetpack', { 'opt': 1 })

" common library
call jetpack#add('vim-denops/denops.vim')
call jetpack#add('nvim-lua/plenary.nvim')
call jetpack#add('MunifTanjim/nui.nvim')
call jetpack#add('Shougo/vimproc.vim', { 'build' : 'make' })
call jetpack#add('vim-jp/vital.vim')

call jetpack#add('vim-jp/vimdoc-ja')
call jetpack#add('ryanoasis/vim-devicons')
call jetpack#add('editorconfig/editorconfig-vim')
call jetpack#add('w0ng/vim-hybrid') " colorscheme
call jetpack#add('navarasu/onedark.nvim') " colorscheme

" DO NOT lazy load
" call jetpack#add('lambdalisue/readablefold.vim')
" call jetpack#add('Yggdroot/indentLine') " NOTE: archived on Jul 29, 2023
call jetpack#add('machakann/vim-sandwich')
" call jetpack#add('luochen1990/rainbow')
call jetpack#add('segeljakt/vim-silicon') " code snapshot tool helper
call jetpack#add('previm/previm')
call jetpack#add('shinespark/vim-list2tree') " NOTE: (m) make directory tree format txt from markdown lists
call jetpack#add('AndrewRadev/linediff.vim')
call jetpack#add('lambdalisue/vim-manpager')

" depends on denops
call jetpack#add('lambdalisue/kensaku.vim') " search Japanese by megemo
call jetpack#add('lambdalisue/kensaku-search.vim')
call jetpack#add('lambdalisue/kensaku-command.vim')
call jetpack#add('yuki-yano/fuzzy-motion.vim') " pounce like motion plugin

" lua plugin
call jetpack#add('nvim-lualine/lualine.nvim')
call jetpack#add('gen740/SmoothCursor.nvim')
call jetpack#add('lewis6991/gitsigns.nvim')

" lazy
call jetpack#add('glidenote/memolist.vim')
call jetpack#add('hrsh7th/cmp-buffer')
call jetpack#add('hrsh7th/cmp-path')
call jetpack#add('hrsh7th/cmp-cmdline')
call jetpack#add('hrsh7th/nvim-cmp')
call jetpack#add('biosugar0/cmp-claudecode')

call jetpack#add('nvim-tree/nvim-web-devicons')

" call jetpack#add('mbbill/undotree')
call jetpack#add('voldikss/vim-floaterm')
call jetpack#add('fatih/vim-go', {
      \ 'on_ft': 'go',
      \ })

call jetpack#add('lambdalisue/fern.vim')
call jetpack#add('lambdalisue/fern-git-status.vim')
call jetpack#add('lambdalisue/nerdfont.vim')
call jetpack#add('lambdalisue/fern-renderer-nerdfont.vim')
call jetpack#add('lambdalisue/glyph-palette.vim')
call jetpack#add('lambdalisue/fern-hijack.vim')

call jetpack#add('junegunn/fzf')
call jetpack#add('junegunn/fzf.vim')
call jetpack#add('rlane/pounce.nvim')
call jetpack#add('folke/todo-comments.nvim')

call jetpack#add('nvim-treesitter/nvim-treesitter', {
      \ 'do': ':TSUpdate'
      \ })
call jetpack#add('rhysd/committia.vim', {
      \ 'on_ft': ['gitcommit', 'git', 'gina-commit'],
      \ })

call jetpack#add('neoclide/coc.nvim', {
      \ 'branch': 'release',
      \ })
call jetpack#add('cohama/lexima.vim')

" better asterisk behavior
call jetpack#add('haya14busa/vim-asterisk')
call jetpack#add('kevinhwang91/nvim-hlslens')
call jetpack#add('mattn/emmet-vim', {
      \ 'on_ft': ['html', 'vue', 'html.twig'],
      \ })
call jetpack#add('t9md/vim-choosewin')
call jetpack#add('ntpeters/vim-better-whitespace')
call jetpack#add('machakann/vim-highlightedyank') " 2026-01-12: undo-glow.nvim に任せてもよいかも
" read vim command result to buffer
call jetpack#add('tyru/capture.vim')
call jetpack#add('mattn/vim-maketable', {
      \ 'on_ft': ['md', 'markdown']
      \ })
call jetpack#add('jodosha/vim-godebug', {
      \ 'on_ft': 'go'
      \ })
" automatic closing of quotes, parenthesis, brackets, etc.
" call jetpack#add('Raimondi/delimitMate')
" easy grep tool
call jetpack#add('windwp/nvim-spectre')
call jetpack#add('simeji/winresizer')
" for commenting on vue SFC
call jetpack#add('tomtom/tcomment_vim')
call jetpack#add('vim-test/vim-test')
" mark colors to words and sentences
call jetpack#add('t9md/vim-quickhl')
" realize live substitute
call jetpack#add('markonm/traces.vim')
call jetpack#add('tyru/open-browser.vim')
call jetpack#add('mtdl9/vim-log-highlighting', {
      \ 'on_ft': ['log']
      \ })
" NOTE: (m) show git diff on git rebase
call jetpack#add('hotwatermorning/auto-git-diff', {
      \ 'on_ft': ['gitcommit', 'git']
      \ })
call jetpack#add('mzlogin/vim-markdown-toc', {
      \ 'on_ft': ['md', 'markdown']
      \ })
" call jetpack#add('alvan/vim-closetag', {
"       \ 'on_ft': ['html', 'vue', 'html.twig']
"       \ })
" call jetpack#add('ap/vim-css-color', {
"       \ 'on_ft': ['html', 'vue', 'html.twig', 'vim', 'lua', 'css', 'scss', 'astro', 'jsx', 'tsx']
"       \ })
call jetpack#add('ap/vim-css-color')
call jetpack#add('posva/vim-vue', {
      \ 'on_ft': ['vue']
      \ })
call jetpack#add('mattn/vim-sqlfmt', {
      \ 'on_ft': ['sql']
      \ })
call jetpack#add('lambdalisue/gina.vim')
call jetpack#add('nvim-neo-tree/neo-tree.nvim', {
      \ 'branch': 'v3.x',
      \ })
call jetpack#add('chrisbra/csv.vim', {
      \ 'on_ft': ['csv']
      \ })

" 2024
call jetpack#add('mvllow/modes.nvim')
call jetpack#add('stevearc/aerial.nvim')
call jetpack#add('MattesGroeger/vim-bookmarks')
call jetpack#add('shellRaining/hlchunk.nvim')
call jetpack#add('kazhala/close-buffers.nvim')
call jetpack#add('Wansmer/treesj')
call jetpack#add('thinca/vim-qfreplace')
" call jetpack#add('rhysd/clever-f.vim')
call jetpack#add('folke/noice.nvim')
call jetpack#add('vim-skk/skkeleton')
call jetpack#add('delphinus/skkeleton_indicator.nvim')
call jetpack#add('will133/vim-dirdiff')
call jetpack#add('nacro90/numb.nvim')
call jetpack#add('atusy/treemonkey.nvim')
call jetpack#add('nvim-treesitter/nvim-treesitter-context')
call jetpack#add('stevearc/quicker.nvim')
call jetpack#add('kevinhwang91/nvim-bqf')
call jetpack#add('jiaoshijie/undotree')
call jetpack#add('windwp/nvim-ts-autotag')
call jetpack#add('ellisonleao/gruvbox.nvim')
call jetpack#add('kana/vim-operator-user')
call jetpack#add('kana/vim-operator-replace')
call jetpack#add('davidoc/taskpaper.vim')
call jetpack#add('uga-rosa/ccc.nvim')
call jetpack#add('lambdalisue/vim-initial')
" call jetpack#add('maguroguma/vim-initial', { 'branch': 'feat/arrange-index-letters' })
" call jetpack#add('kevinhwang91/promise-async')
" call jetpack#add('kevinhwang91/nvim-ufo')
call jetpack#add('A7Lavinraj/fyler.nvim')
call jetpack#add('nvim-mini/mini.icons') " for fyler.nvim
call jetpack#add('backdround/global-note.nvim')
" call jetpack#add('TaDaa/vimade')
call jetpack#add('chrisgrieser/nvim-origami')
call jetpack#add('pwntester/octo.nvim')
call jetpack#add('y3owk1n/undo-glow.nvim')

" for avante
call jetpack#add('stevearc/dressing.nvim')
call jetpack#add('MeanderingProgrammer/render-markdown.nvim')
call jetpack#add('ibhagwan/fzf-lua')
call jetpack#add('yetone/avante.nvim', { 'branch': 'main', 'do': 'make' })
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
let maplocalleader = "\<Space>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SECTION: main settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: junegunn/fzf.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""
" commands
"""
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(
    \   <q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}),
    \   <bang>0)

command! -bang -nargs=? -complete=dir Buffers
    \ call fzf#vim#buffers(
    \   <q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}),
    \   <bang>0)

" deletes buffers by fzf
" ref: https://github.com/junegunn/fzf.vim/pull/733#issuecomment-559720813
function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:list_buffers_customized()
  redir => list
  silent ls
  redir END

  let l:res = []
  let l:raw_lines = split(list, "\n")
  for l:raw_line in raw_lines
    let l:elems = split(l:raw_line)
    let l:custom_line = l:elems[0] . "\t" . substitute(l:elems[2], '"', "", "g")
    call add(l:res, l:custom_line)
  endfor
 return l:res
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers_customized(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept --prompt "delete(close) buffers> "'
\ }))

"""
" custom git show with gina.vim
"""
" source
function! s:list_commits() abort
  let l:res = system('git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --color=always')
  return split(l:res, "\n")
endfunction
" sink
function! s:select_commits(commit_hash) abort
  let l:list = split(a:commit_hash, ' ')
  let l:execute_command = 'Gina show ' . l:list[1] . ':%'
  execute l:execute_command
endfunction
command! GinaShow call fzf#run(fzf#wrap({
  \ 'source': s:list_commits(),
  \ 'sink': funcref('s:select_commits'),
  \ 'options': '--ansi --prompt "git show of the buffer> "',
\ }))

"""
" custom insert command from history
"""
" source
function! s:list_command_history() abort
  let l:res = system("cat $HISTFILE | cut -b 16- | head -n 5000")
  return reverse(split(l:res, "\n"))
endfunction
" sink
function! s:insert_target(shell_command) abort
  execute 'normal! i' . a:shell_command
endfunction
command! HCommand call fzf#run(fzf#wrap({
  \ 'source': s:list_command_history(),
  \ 'sink': funcref('s:insert_target'),
  \ 'options': '--ansi --prompt "insert command> "',
\ }))

"""
" custom insert command from the custom dictionary file
"""
" source
function! s:list_custom_dictyonary() abort
  let l:res = system("cat $XDG_CONFIG_HOME/nvim/fzf-any-dictionary")
  return split(l:res, "\n")
endfunction
command! FzfFromCustomFile call fzf#run(fzf#wrap({
  \ 'source': s:list_custom_dictyonary(),
  \ 'sink': funcref('s:insert_target'),
  \ 'options': '--ansi --prompt "insert something> "',
\ }))

"""
" easy MRU
"""
command! Fmru FZFMru
command! FZFMru call fzf#run(fzf#wrap({
  \ 'source': v:oldfiles,
  \ 'sink': 'e',
\}))

"""
" layouts, styles
"""

" popup window
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.6, 'yoffset': 0.5 } }

" Empty value to disable preview window altogether
let g:fzf_preview_window = []

" short map
" nnoremap <silent> <C-p> <cmd>Files<CR>
" nnoremap <silent> ; <cmd>Buffers<CR>
" nnoremap <silent> , <cmd>GitFiles?<CR>
nnoremap <silent> <C-p> <cmd>FzfLua files<CR>
nnoremap <silent> ; <cmd>FzfLua buffers<CR>
nnoremap <silent> , <cmd>FzfLua git_status<CR>

" nnoremap <silent> <Space>h <cmd>Helptags<CR>
" nnoremap <silent> <Space>q <cmd>History:<CR>
nnoremap <silent> <Space>H <cmd>FzfLua helptags<CR>
nnoremap <silent> Q <cmd>FzfLua command_history<CR>
nnoremap <silent> <Space>q <cmd>FzfLua command_history<CR>
nnoremap <silent> ? <cmd>FzfLua search_history<CR>
nnoremap <silent> <Space>/ <cmd>FzfLua search_history<CR>
nnoremap <silent> <Space>j <cmd>FzfLua jumps<CR>

nnoremap <silent> <Space>bd <cmd>BD<CR>

" show maps map
nmap <Space><tab> <plug>(fzf-maps-n)
xmap <Space><tab> <plug>(fzf-maps-x)
omap <Space><tab> <plug>(fzf-maps-o)
imap <C-a><tab> <plug>(fzf-maps-i)

" Global line completion (not just open buffers. ripgrep required.)
inoremap <expr> <c-x><c-l> fzf#vim#complete(fzf#wrap({
  \ 'prefix': '^.*$',
  \ 'source': 'rg -n ^ --color always',
  \ 'options': '--ansi --delimiter : --nth 3..',
  \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }
\}))

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

" Path completion with custom source command
inoremap <expr> <C-a>f fzf#vim#complete#path('rg --files')
" Shell history completion
inoremap <C-a>r <cmd>HCommand<CR>
inoremap <C-a>R <cmd>HCommand<CR>
" Word completion with custom source command
inoremap <C-a>F <cmd>FzfFromCustomFile<CR>

" Word completion with custom spec with popup layout option
" inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: nvim-neo-tree/neo-tree.nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <C-f> <cmd>Neotree reveal<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: lambdalisue/gina.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set diffopt+=vertical
" 現在のバッファ
" 現在のバッファのファイルをcheckoutする
function! s:gitCheckoutThis()
  let l:confirm_msg = 'You checkout this buffer file, OK?'
  let l:is_ok = confirm(l:confirm_msg, "y yes\nn no")
  if l:is_ok != 1
    return
  endif
  :Gina checkout %
endfunction
nnoremap <Space>ga <cmd>Gina add %<CR>
nnoremap <Space>gu <cmd>Gina reset HEAD %<CR>
nnoremap <Space>gc <cmd>GinaCheckoutThis<CR>
nnoremap <Space>gd <cmd>Gina diff :%<CR>
nnoremap <Space>gD <cmd>Gina diff --staged :%<CR>

" 全体
nnoremap <Space>gp <cmd>Gina patch --oneside<CR>
nnoremap <Space>gs <cmd>Gina status<CR>
nnoremap <Space>gl <cmd>Gina log<CR>
" nnoremap <Space>gb <cmd>execute 'Gina blame --width=' . (&columns / 2)<CR>
nnoremap <Space>Gd <cmd>Gina diff<CR>
nnoremap <Space>GD <cmd>Gina diff --staged<CR>

function! BrowseRevision(revision)
  if a:revision == ''
    let l:revision = 'HEAD'
  else
    let l:revision = a:revision
  endif

  let l:cmd = 'Gina browse --exact ' . l:revision . ':%'
  execute l:cmd
  echo '[RUN] ' . l:cmd
endfunction

function! BrowseRevisionRange(line1, line2, revision)
  if a:revision == ''
    let l:revision = 'HEAD'
  else
    let l:revision = a:revision
  endif

  let l:cmd = a:line1 . ',' . a:line2 . 'Gina browse --exact ' . l:revision . ':%'
  execute l:cmd
  echo '[RUN] ' . l:cmd
endfunction

command! GinaDiffAll Gina diff
command! GinaDiffStagedAll Gina diff --staged
command! GinaCheckoutThis :call s:gitCheckoutThis()

" commit は tabnew で開く
command! GinaCommit tabnew | execute 'Gina commit'
command! GinaCommitAmend tabnew | execute 'Gina commit --amend'

" 引数として branch 等の ref を取れる（デフォルトは現在の ref となる）
command! -nargs=? GinaBrowseThis :call BrowseRevision(<q-args>)
command! -range -nargs=? GinaBrowseThese :call BrowseRevisionRange(<line1>, <line2>, <q-args>)

let g:gina#command#blame#formatter#format = "%su%=on %au %ti %ma%in"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: luochen1990/rainbow
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: tyru/open-browser.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: haya14busa/vim-asterisk
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: t9md/vim-quickhl
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap M <Plug>(quickhl-manual-this-whole-word)
xmap M <Plug>(quickhl-manual-this)
nmap ma <Plug>(quickhl-manual-this)
nmap mq <Plug>(quickhl-manual-reset)

let g:quickhl_manual_keywords = [
      \ 'FACT:',
      \ 'IMO:',
      \]
let g:quickhl_manual_enable_at_startup = 1
let g:quickhl_manual_colors = [
      \ "cterm=bold ctermfg=12 ctermbg=64  gui=bold guibg=#FFC300 guifg=#ffffff",
      \ "cterm=bold ctermfg=7  ctermbg=5   gui=bold guibg=#0070e0 guifg=#ffffff",
      \ "cterm=bold ctermfg=16 ctermbg=153 gui=bold guibg=#0a7383 guifg=#ffffff",
      \ "cterm=bold ctermfg=7  ctermbg=1   gui=bold guibg=#a07040 guifg=#ffffff",
      \ "cterm=bold ctermfg=7  ctermbg=2   gui=bold guibg=#4070a0 guifg=#ffffff",
      \ "cterm=bold ctermfg=7  ctermbg=3   gui=bold guibg=#40a070 guifg=#ffffff",
      \ "cterm=bold ctermfg=7  ctermbg=4   gui=bold guibg=#70a040 guifg=#ffffff",
      \ "cterm=bold ctermfg=7  ctermbg=6   gui=bold guibg=#007020 guifg=#ffffff",
      \ "cterm=bold ctermfg=7  ctermbg=21  gui=bold guibg=#d4a00d guifg=#ffffff",
      \ "cterm=bold ctermfg=7  ctermbg=22  gui=bold guibg=#06287e guifg=#ffffff",
      \ "cterm=bold ctermfg=7  ctermbg=45  gui=bold guibg=#5b3674 guifg=#ffffff",
      \ "cterm=bold ctermfg=7  ctermbg=16  gui=bold guibg=#4c8f2f guifg=#ffffff",
      \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
      \ "cterm=bold ctermfg=7  ctermbg=56  gui=bold guibg=#a0b0c0 guifg=black",
      \ "cterm=bold ctermfg=8  ctermbg=60  gui=bold guibg=#FF5733 guifg=#ffffff",
      \ "cterm=bold ctermfg=9  ctermbg=61  gui=bold guibg=#C70039 guifg=#ffffff",
      \ "cterm=bold ctermfg=10 ctermbg=62  gui=bold guibg=#900C3F guifg=#ffffff",
      \ "cterm=bold ctermfg=11 ctermbg=63  gui=bold guibg=#581845 guifg=#ffffff",
      \ "cterm=bold ctermfg=12 ctermbg=64  gui=bold guibg=#7F00FF guifg=#ffffff",
      \ "cterm=bold ctermfg=13 ctermbg=65  gui=bold guibg=#FF007F guifg=#ffffff",
      \ "cterm=bold ctermfg=14 ctermbg=66  gui=bold guibg=#00FFFF guifg=#000000",
      \ "cterm=bold ctermfg=15 ctermbg=67  gui=bold guibg=#FFFF00 guifg=#000000",
      \ "cterm=bold ctermfg=16 ctermbg=68  gui=bold guibg=#FF7F00 guifg=#ffffff",
      \ "cterm=bold ctermfg=17 ctermbg=69  gui=bold guibg=#7FFF00 guifg=#000000",
      \ "cterm=bold ctermfg=18 ctermbg=70  gui=bold guibg=#00FF00 guifg=#000000",
      \ "cterm=bold ctermfg=19 ctermbg=71  gui=bold guibg=#007FFF guifg=#ffffff",
      \ ]

nnoremap <Space>M :QuickhlManualAdd! <C-r>/<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: windwp/nvim-spectre
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <Space>s <cmd>Spectre<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: t9md/vim-choosewin
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap so <cmd>ChooseWin<CR>
" オーバーレイ機能を有効にしたい場合
let g:choosewin_overlay_enable          = 1
" オーバーレイ・フォントをマルチバイト文字を含むバッファでも綺麗に表示する。
let g:choosewin_overlay_clear_multibyte = 1
let g:choosewin_label = 'HJKLYUIONM'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: glidenote/memolist.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <Space>mn  <cmd>MemoNew<CR>
nnoremap <Space>ml  <cmd>MemoList<CR>
nnoremap <Space>mg  <cmd>MemoGrep<CR>

let g:memolist_path = expand("$GOPATH/src/github.com/maguroguma/memolist")
let g:memolist_memo_suffix = "md"
let g:memolist_memo_date = "%Y-%m-%d %H:%M"
let g:memolist_prompt_tags = 1
let g:memolist_prompt_categories = 1
let g:memolist_fzf = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: w0ng/vim-hybrid
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set termguicolors
set background=light
colorscheme gruvbox

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: mbbill/undotree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

noremap <Space>u <cmd>UndotreeToggle<CR>
let g:undotree_WindowLayout = 2         " undotreeは左側/diffは下にウィンドウ幅で表示
let g:undotree_ShortIndicators = 1      " 時間単位は短く表示
let g:undotree_SplitWidth = 40          " undotreeのウィンドウ幅
let g:undotree_SetFocusWhenToggle = 1   " undotreeを開いたらフォーカスする
"let g:undotree_DiffAutoOpen = 0         " diffウィンドウは起動時無効
let g:undotree_DiffpanelHeight = 8      " diffウィンドウの行数
"let g:undotree_HighlightChangedText = 0 " 変更箇所のハイライト無効

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: voldikss/vim-floaterm
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <C-s> <cmd>FloatermToggle<CR>
" 参考: https://github.com/yutkat/dotfiles/blob/28e8df61c39727fa85d3f289343eb60feffd29d8/.config/nvim/rc/pluginconfig/vim-floaterm.vim
let g:floaterm_height = 0.97
let g:floaterm_width = 0.98
augroup vimrc_floaterm
  autocmd!
  autocmd User FloatermOpen tnoremap <buffer> <silent> <C-s> <C-\><C-n><cmd>FloatermToggle<CR>
  autocmd QuitPre * FloatermKill!
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: simeji/winresizer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <C-e> <cmd>WinResizerStartResize<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: previm/previm
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:previm_open_cmd = 'open -a Google\ Chrome'
nnoremap <silent> <Space>mp <cmd>PrevimOpen<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: yuki-yano/fuzzy-motion.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:fuzzy_motion_labels = [
      \ 'H', 'J', 'K', 'L', 'Y',
      \ 'U', 'I', 'O', 'P', 'N',
      \ 'M', 'Q', 'W', 'E', 'R',
      \ 'T', 'A', 'S', 'D', 'F',
      \ 'G', 'Z', 'X', 'C', 'V',
      \ 'B'
      \]
highlight FuzzyMotionMatch ctermfg=159 ctermbg=240
highlight FuzzyMotionMatch guifg=#caedfc guibg=#565657
highlight FuzzyMotionChar cterm=bold ctermfg=207
highlight FuzzyMotionChar gui=bold guifg=#ee8bf7
highlight FuzzyMotionSubChar cterm=bold ctermfg=44
highlight FuzzyMotionSubChar gui=bold guifg=#2bb2e3
" highlight FuzzyMotionShade ctermfg=0 ctermbg=0
let g:fuzzy_motion_matchers = ['fzf', 'kensaku']
cnoremap <C-a><CR> <Plug>(kensaku-search-replace)<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: lambdalisue/vim-initial
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap f <Cmd>Initial<CR>
" let g:vim_initial_labels = [
"       \ 'h', 'j', 'k', 'l', 'y',
"       \ 'u', 'i', 'o', 'p', 'n',
"       \ 'm',
"       \]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: machakann/vim-highlightedyank
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:highlightedyank_highlight_duration = 500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: ntpeters/vim-better-whitespace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:better_whitespace_filetypes_blacklist = ['diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'fugitive', 'defx']
let g:better_whitespace_ctermcolor = '12'
highlight ExtraWhitespace ctermbg=159
highlight ExtraWhitespace guibg=#ff9999

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: mattn/emmet-vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:user_emmet_leader_key='<C-e>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: fatih/vim-go
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
" LSPに任せる機能をOFFにする
let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0

" autocmd FileType go nmap <Space>b  <Plug>(go-build)
autocmd FileType go nmap <Space>r  <Plug>(go-run)
autocmd FileType go nmap <Space>t  <Plug>(go-test)
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction
autocmd FileType go nmap <Space>b <cmd>call <SID>build_go_files()<CR>
autocmd FileType go nmap <Space>c <Plug>(go-coverage-toggle)

" ハイライト
" :help go-settings
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

" let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_autosave = 0
" オートで実行するものは選定できる
" let g:go_metalinter_autosave_enabled = ['vet', 'golint']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: rhysd/committia.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" https://zenn.dev/uochan/articles/2021-12-08-vim-conventional-commits
augroup GitCommitKeymap
  autocmd!
  autocmd FileType gitcommit,gina-commit nnoremap <buffer> ZZ <cmd>call g:SelectType()<CR>
augroup END

function! g:SelectType() abort
  if &filetype ==? "gitcommit" || &filetype ==? "gina-commit"
    let line = substitute(getline('.'), '^#\s*', '', 'g') " 最初の '# ' を除く
    let arr = split(line, ' ')
    let title = printf('%s: %s ', arr[0], arr[1])

    silent! normal! "_dip
    silent! put! =title
    silent! startinsert!
  else
    echoerr 'This is not gitcommit buffer!'
    return
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: lambdalisue/fern.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" nmap <C-f> :<C-u>Fern . -reveal=%<CR>
let g:fern#renderer = "nerdfont"
let g:fern#renderer#nerdfont#indent_markers = 1

function! s:init_fern() abort
  " Use 'select' instead of 'edit' for default 'open' action
  " nmap <buffer> <Plug>(fern-action-open) <Plug>(fern-action-open:select)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: neoclide/coc.nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <C-n>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" NOTE: leximaの設定で変更する
" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gh <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
" K -> gh
nnoremap <silent> gh <cmd>call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <Space>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <Space>f  <Plug>(coc-format-selected)
" nmap <Space>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<Space>aap` for current paragraph
xmap <Space>a  <Plug>(coc-codeaction-selected)
nmap <Space>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <Space>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
" nmap <Space>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <Space>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
" xmap if <Plug>(coc-funcobj-i)
" omap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap af <Plug>(coc-funcobj-a)
" xmap ic <Plug>(coc-classobj-i)
" omap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
" if has('nvim-0.4.0') || has('patch-8.2.0750')
"   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" original(from vim-jp)
" https://vim-jp.slack.com/archives/CQ88WB7B3/p1659323660504669
" highlight CocMenuSel cterm=bold ctermbg=18
" highlight CocMenuSel gui=bold
" highlight CocMenuSel guibg=#525151
" highlight CocSearch cterm=bold ctermfg=44
" highlight CocSearch gui=bold
" highlight CocSearch guifg=#C586C0

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" " Mappings for CoCList
" " Show all diagnostics.
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions.
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " Show commands.
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document.
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols.
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list.
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"""
" coc extensions
"""
let g:coc_global_extensions = [
      \ 'coc-syntax',
      \ 'coc-word',
      \ 'coc-json',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-prettier',
      \ 'coc-tsserver',
      \ 'coc-vetur',
      \ 'coc-deno',
      \ '@yaegassy/coc-astro',
      \ 'coc-vimlsp',
      \ 'coc-docker',
      \ 'coc-yaml',
      \ 'coc-sh',
      \ 'coc-pyright',
      \ 'coc-typos',
      \ '@yaegassy/coc-tailwindcss3',
      \ ]

"""
" node path
"""
" let g:coc_node_path = '/path/to/node'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: cohama/lexima.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:lexima_enable_basic_rules = 1

" yuki-yanoさんのスクリプトを参考に
" https://github.com/yuki-yano/dotfiles/blob/1c865f70c5ca3c2b4b59181c30bdb69ac6a0870a/.vimrc
" '\%#' はカーソル位置を表す
function! s:setup_lexima_insert() abort
  let s:rules = []

  "" markdown
  let s:rules += [
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\%#',                        'input': '<C-w><CR>',                         },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><CR>',                    },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s*-\s\w.*\%#',                 'input': '<CR>-<Space>',                      },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\[\%#\]',                    'input': '<End><C-w><C-w><C-w><CR>',          },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\[\%#\]',                'input': '<End><C-w><C-w><C-w><C-w><CR>',     },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><CR>',               },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><CR>',          },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<CR>-<Space>[]<Space><Left><Left>', },
  \ ]
  "" markdown(original)
  let s:rules += [
  \ { 'filetype': 'markdown', 'char': '<Space>', 'at': '\[\%#', 'input': '<Space>'},
  \ ]

  for s:rule in s:rules
    call lexima#add_rule(s:rule)
  endfor
endfunction

function! SetupLexima() abort
  call s:setup_lexima_insert()
endfunction

call SetupLexima()

" cocの補完をEnterで決定する（leximaの設定を上書きする）
inoremap <silent><expr> <C-k><C-j> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" helpより
inoremap <silent><expr> <CR> coc#pum#visible() ? "\<CR>" :
      \ "\<C-g>u\<C-r>=lexima#expand('<LT>CR>', 'i')\<CR><C-r>=coc#on_enter()\<CR>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: MattesGroeger/vim-bookmarks
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:bookmark_no_default_key_mappings = 1
let g:bookmark_save_per_working_dir = 1

nmap mm <Plug>BookmarkToggle
" nmap <Leader>i <Plug>BookmarkAnnotate
nmap ml <Plug>BookmarkShowAll
" nmap <Leader>j <Plug>BookmarkNext
" nmap <Leader>k <Plug>BookmarkPrev
" nmap <Leader>c <Plug>BookmarkClear
" nmap <Leader>x <Plug>BookmarkClearAll
" nmap <Leader>kk <Plug>BookmarkMoveUp
" nmap <Leader>jj <Plug>BookmarkMoveDown
" nmap <Leader>g <Plug>BookmarkMoveToLine

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SECTION: lua scripts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set completeopt=menu,menuone,noselect
set pumheight=20

lua require('myconfig')

" copilot.lua, CopilotChat.nvim setting
let s:copilot_setting_file = expand('$XDG_CONFIG_HOME/nvim/lua/copilot-setting.lua')
if filereadable(s:copilot_setting_file)
  lua require('copilot-setting')
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: rlane/pounce.nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" nmap ' <cmd>Pounce<CR>
nmap ' <cmd>FuzzyMotion<CR>
vmap ' <cmd>Pounce<CR>
omap g' <cmd>Pounce<CR>

" pounce
" highlight PounceMatch      cterm=underline,bold ctermfg=49 ctermbg=236
" highlight PounceMatch      gui=underline,bold guifg=#555555 guibg=#FFAF60
" highlight PounceGap        cterm=underline,bold ctermfg=214 ctermbg=236
" highlight PounceGap        gui=underline,bold guifg=#555555 guibg=#E27878
" highlight PounceAccept     cterm=underline,bold ctermfg=184 ctermbg=236
" highlight PounceAccept     gui=underline,bold guifg=#FFAF60 guibg=#555555
" highlight PounceAcceptBest cterm=underline,bold ctermfg=196 ctermbg=236
" highlight PounceAcceptBest gui=underline,bold guifg=#EE2513 guibg=#555555

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: Wansmer/treesj
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <Space>t <cmd>TSJToggle<CR>
" nnoremap <Space>s <cmd>TSJSplit<CR>
" nnoremap <Space>j <cmd>TSJJoin<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: rhysd/clever-f.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:clever_f_smart_case = 1
" let g:clever_f_use_migemo = 1
" " let g:clever_f_mark_char_color = 'FuzzyMotionChar'
" let g:clever_f_chars_match_any_signs = ';'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: vim-skk/skkeleton
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call skkeleton#config(
      \ {
      \ 'globalDictionaries': [
        \ '~/.skk/SKK-JISYO.L',
        \ '~/.skk/SKK-JISYO.fullname',
        \ '~/.skk/SKK-JISYO.geo',
        \ '~/.skk/SKK-JISYO.jinmei',
        \ '~/.skk/SKK-JISYO.law',
        \ '~/.skk/SKK-JISYO.propernoun',
        \ '~/.skk/SKK-JISYO.station',
      \ ],
      \ 'eggLikeNewline': v:true,
      \ 'immediatelyCancel': v:false,
      \})
imap <C-j> <Plug>(skkeleton-enable)
cmap <C-j> <Plug>(skkeleton-enable)
tmap <C-j> <Plug>(skkeleton-enable)

augroup skkeleton-coc
  autocmd!
  autocmd User skkeleton-enable-pre let b:coc_suggest_disable = v:true
  autocmd User skkeleton-disable-pre let b:coc_suggest_disable = v:false
augroup END

call skkeleton#register_kanatable('rom', {
      \ '(' : ['（', ''],
      \ ')' : ['）', ''],
      \})

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: colorscheme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:colorschemeLightOnedark()
  set background=light
  colorscheme onedark
endfunction
command! -nargs=0 LightOnedark call s:colorschemeLightOnedark()

function! s:colorschemeDarkHybrid()
  set background=dark
  colorscheme hybrid
endfunction
command! -nargs=0 DarkHybrid call s:colorschemeDarkHybrid()

" augroup ChangeColorschemeOnMacro
"   autocmd!
"   autocmd RecordingEnter * LightOnedark
"   autocmd RecordingLeave * DarkHybrid
" augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: kana/vim-operator-user
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" e.g.: visual 時に _ すると、無名レジスタを汚さず置換できる
map _ <Plug>(operator-replace)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGSETTING: davidoc/taskpaper.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" TaskPaper.vim カスタムタグのスタイル設定
let g:task_paper_styles={
    \ 'urgent': 'ctermbg=214 guibg=#cccc00 ctermfg=black guifg=#000000',
    \ 'important': 'ctermbg=69 guibg=#cccc00 ctermfg=white guifg=#000000',
    \ 'risky': 'ctermbg=167 guibg=#cccc00 ctermfg=white guifg=#000000',
    \ 'inProgress': 'ctermbg=108 guibg=#d75f5f ctermfg=black guifg=#ffffff',
    \ }

" due タグのハイライト設定
let g:taskpaper_due_highlight = get(g:, 'taskpaper_due_highlight', {})

" デフォルト設定
let g:taskpaper_due_highlight = extend({
    \ 'critical_days': 7,
    \ 'warning_days': 28,
    \ 'critical_style': 'ctermbg=196 guibg=#d75f5f ctermfg=white guifg=#ffffff',
    \ 'warning_style': 'ctermbg=214 guibg=#eaaf00 ctermfg=black guifg=#000000',
    \ 'normal_style': 'ctermbg=40 guibg=#87af87 ctermfg=black guifg=#000000',
    \ }, g:taskpaper_due_highlight)

" ハイライトグループを動的に定義
execute 'highlight DueCritical ' . g:taskpaper_due_highlight.critical_style
execute 'highlight DueWarning ' . g:taskpaper_due_highlight.warning_style
execute 'highlight DueNormal ' . g:taskpaper_due_highlight.normal_style

function! s:calculate_date_diff(date_str)
  let l:due_timestamp = strptime('%Y-%m-%d', a:date_str)
  let l:today_timestamp = localtime()
  let l:today_start = l:today_timestamp - (l:today_timestamp % 86400)
  let l:due_start = l:due_timestamp - (l:due_timestamp % 86400)

  return (l:due_start - l:today_start) / 86400
endfunction

function! s:update_due_highlights()
  for l:line_num in range(1, line('$'))
    let l:line = getline(l:line_num)
    let l:match = matchstr(l:line, '@due(\d\{4\}-\d\{2\}-\d\{2\})')

    if l:match != ''
      let l:date_str = substitute(l:match, '@due(\(\d\{4\}-\d\{2\}-\d\{2\}\))', '\1', '')
      let l:diff_days = s:calculate_date_diff(l:date_str)

      let l:pattern = '\%' . l:line_num . 'l@due(\d\{4\}-\d\{2\}-\d\{2\})'
      if l:diff_days <= g:taskpaper_due_highlight.critical_days
        call matchadd('DueCritical', l:pattern)
      elseif l:diff_days <= g:taskpaper_due_highlight.warning_days
        call matchadd('DueWarning', l:pattern)
      else
        call matchadd('DueNormal', l:pattern)
      endif
    endif
  endfor
endfunction

function! s:taskpaper_setup()
  " Your settings
  nnoremap <buffer> <silent> <Leader>tu
  \    :<C-u>call taskpaper#toggle_tag('urgent', '')<CR>
  nnoremap <buffer> <silent> <Leader>ti
  \    :<C-u>call taskpaper#toggle_tag('important', '')<CR>
  nnoremap <buffer> <silent> <Leader>tr
  \    :<C-u>call taskpaper#toggle_tag('risky', '')<CR>
  nnoremap <buffer> <silent> <Leader>tg
  \    :<C-u>call taskpaper#toggle_tag('inProgress', '')<CR>

  " due タグのハイライトを初期化と更新
  call s:update_due_highlights()

  " ファイル保存時やテキスト変更時にハイライトを更新
  autocmd BufWritePost,TextChanged,TextChangedI <buffer> call s:update_due_highlights()
endfunction

function! s:handle_taskpaper_highlights()
  " taskpaperファイルの場合のみハイライトを更新
  if &filetype == 'taskpaper'
    call s:update_due_highlights()
  endif
endfunction

augroup vimrc-taskpaper
  autocmd!
  autocmd FileType taskpaper call s:taskpaper_setup()
  " バッファに入った時の処理（taskpaperならハイライト更新、他ならクリア）
  autocmd BufEnter * call s:handle_taskpaper_highlights()
augroup END

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

inoremap <C-a>day <C-r>=strftime("%Y-%m-%d")<CR>
cnoremap <C-a>day <C-r>=strftime("%Y-%m-%d")<CR>
inoremap <C-a>time <C-r>=strftime("%Y-%m-%d %T")<CR>
inoremap <C-a>tengu TENGU 👺 >
inoremap <C-a>sr <strong><span style="color:red;"></span></strong>

" fzfで日付を入力したい
function g:TerminalDay()
  let l:temp = @z
  let @z = strftime("%Y-%m-%d")
  put! z
  let @z = l:temp
  norm a
endfunction
tnoremap <C-a>day <C-\><C-n><cmd>call g:TerminalDay()<CR>

" markdownのコードブロック関数（統合版）
function! InsertCodeBlock()
  let l:lang = input("言語指定（省略可）: ")
  let l:text = "```" . l:lang . "\n```"
  let l:tmp = @a
  let @a = l:text
  execute 'normal "ap'
  let @a = l:tmp
  " カーソルを開始タグと終了タグの間に移動
  execute 'normal k$'
endfunction

function! SurroundWithCodeBlock() range
  let l:lang = input("言語指定（省略可）: ")

  " 単一のundo操作として実行
  let l:start_line = a:firstline
  let l:end_line = a:lastline
  let l:save_cursor = getpos('.')

  " 終了行の後に```を追加
  call append(l:end_line, '```')
  " 開始行の前に```langを追加
  call append(l:start_line - 1, '```' . l:lang)

  call setpos('.', l:save_cursor)
endfunction

function! QuoteSelectedLines() range
  let l:start_line = a:firstline
  let l:end_line = a:lastline

  for l:line_num in range(l:start_line, l:end_line)
    let l:current_line = getline(l:line_num)
    if l:current_line =~ '^\s*$'
      call setline(l:line_num, '>')
    else
      call setline(l:line_num, '> ' . l:current_line)
    endif
  endfor
endfunction

function! s:markdown_bold_visual() range
  " 現在の選択を記録
  let l:save_reg = @@
  let l:save_regtype = getregtype('"')

  " 選択されたテキストを取得
  normal! gv"xy
  let l:selected_text = @x

  " 選択位置情報を取得
  let l:start_line = line("'<")
  let l:start_col = col("'<")
  let l:end_col = col("'>")

  let l:line = getline(l:start_line)

  " 前後の文字を確認（バイト単位で）
  let l:is_line_start = (l:start_col == 1)
  let l:is_line_end = (l:end_col == col('$') - 1)

  let l:before_char = l:is_line_start ? '' : l:line[l:start_col - 2]
  let l:after_char = l:is_line_end ? '' : l:line[l:end_col]

  " 先頭に追加するテキストを決定
  let l:prefix = '**'
  if !l:is_line_start && l:before_char != ' '
    let l:prefix = ' **'
  endif

  " 末尾に追加するテキストを決定
  let l:suffix = '**'
  if !l:is_line_end && l:after_char != ' '
    let l:suffix = '** '
  endif

  " 置換テキストを作成
  let l:replacement = l:prefix . l:selected_text . l:suffix

  " 選択範囲を置換
  normal! gvd
  execute "normal! i" . l:replacement

  " レジスタを復元
  call setreg('"', l:save_reg, l:save_regtype)
endfunction

autocmd FileType markdown nnoremap <buffer> <Space>` :call InsertCodeBlock()<CR>
autocmd FileType markdown vnoremap <buffer> <Space>` :call SurroundWithCodeBlock()<CR>
autocmd FileType markdown vnoremap <buffer> <Space>mq :call QuoteSelectedLines()<CR>
autocmd FileType markdown vnoremap <silent> <Space>mb :<C-u>call <SID>markdown_bold_visual()<CR>

" TODOリスト（markdownファイル専用）
" Thanks to https://qiita.com/naoty_k/items/56eddc9b76fe630f9be7
augroup markdown_todo
  autocmd!
  autocmd FileType markdown inoremap <buffer> <C-a>tl <C-r>='- [ ] '<CR>
  autocmd FileType markdown nnoremap <buffer> <Space>x <cmd>call ToggleCheckbox()<CR>
augroup END

" 選択行のチェックボックスを切り替える
function! ToggleCheckbox()
  let l:line = getline('.')
  if l:line =~ '\-\s\[\s\]'
    let l:result = substitute(l:line, '-\s\[\s\]', '- [x]', '')
    call setline('.', l:result)
  elseif l:line =~ '\-\s\[x\]'
    let l:result = substitute(l:line, '-\s\[x\]', '- [ ]', '')
    call setline('.', l:result)
  end
endfunction

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
tnoremap <C-\> <C-\><C-n>

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

" nkfコマンドが実行可能な場合
" 行Visualで指定した範囲に対して `nkf -Z0` （全角英数字・記号→半角に変換）を行う
if executable('nkf')
  function! s:nkf(has_bang, ...) abort range
    execute 'silent' a:firstline ',' a:lastline '!nkf -Z0'
  endfunction

  command! -bar -bang -range=% -nargs=? Nkf  <line1>,<line2>call s:nkf(<bang>0, <f-args>)
endif

command! -nargs=? TrimWhiteSpaces :%s/\s\+$//g

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
" https://zenn.dev/vim_jp/articles/quickfix-plugins-2025#%3Agrep%E3%81%A7ripgrep%E3%82%92%E4%BD%BF%E3%81%86
if executable('rg')
  let &grepprg = 'rg --vimgrep --smart-case --hidden'
  set grepformat=%f:%l:%c:%m
endif

" :grepのショートカット
function! s:grep_cur_dir()
  let l:regexp = input("grep(rg) pattern: ")
  if l:regexp == ""
    echo "grep canceled."
    return
  endif
  let l:command = 'grep ' . l:regexp . '| copen'
  execute 'silent ' .. l:command
  if len(getqflist()) == 0
    echoerr 'not found: ' . l:command
  endif
endfunction
command! -nargs=0 MyGrepCommand :call s:grep_cur_dir()
nnoremap <Space>gr <cmd>MyGrepCommand<CR>

function! ReverseLines() range
    let l:lines = getline(a:firstline, a:lastline)
    call reverse(l:lines)
    call setline(a:firstline, l:lines)
endfunction

command! -range -nargs=0 Reverse :<line1>,<line2>call ReverseLines()

command! -range=% SplitPeriods <line1>,<line2>s/。/。\r/g

function! EncloseWithParens(left, right)
    " 選択範囲の開始と終了を取得
    let start = getpos("'<")
    let end = getpos("'>")

    " 終了位置に後ろの括弧を挿入
    call setpos('.', end)
    execute "normal! a" . a:right

    " 開始位置に前の括弧を挿入
    call setpos('.', start)
    execute "normal! i" . a:left
endfunction

" 全角丸括弧で囲むためのマッピング
xnoremap g( :call EncloseWithParens('（', '）')<CR>
xnoremap g) :call EncloseWithParens('（', '）')<CR>
xnoremap gs :call EncloseWithParens('「', '」')<CR>
xnoremap g[ :call EncloseWithParens('【', '】')<CR>
xnoremap g] :call EncloseWithParens('【', '】')<CR>

" 和集合を検索する
" カーソル下のワードを検索パターンに追加
nnoremap <Space>* <cmd>call AddSearchWord()<CR>

function! AddSearchWord()
    let l:word = expand('<cword>')
    if @/ == ''
        let @/ = '\<' . l:word . '\>'
    else
        let @/ .= '\|\<' . l:word . '\>'
    endif
endfunction

" カレントバッファのパスを取得する
function! YankCurrentBufferFileRelativePath()
  let l:relative_path = expand("%")
  let l:cur_lnumber = line(".")
  let l:res = l:relative_path . "#L" . l:cur_lnumber
  let @" = l:res
  let @+ = l:res
  echo 'Path copied to clipboard: ' . l:res
endfunction
function! YankCurrentBufferFileFullPath()
  let l:full_path = expand("%:p")
  let l:cur_lnumber = line(".")
  let l:res = l:full_path . "#L" . l:cur_lnumber
  let @" = l:res
  let @+ = l:res
  echo 'Full path copied to clipboard: ' . l:res
endfunction
command! YankBufferPath :call YankCurrentBufferFileRelativePath()
command! YankBufferPathFully :call YankCurrentBufferFileFullPath()

function! YankVisualRangeWithPath() range
  let l:relative_path = expand("%:.")
  let l:start_line = a:firstline
  let l:end_line = a:lastline
  let l:res = l:relative_path . ":" . l:start_line . "-" . l:end_line
  let @+ = l:res
  let @" = l:res
  echo 'Range path copied to clipboard: ' . l:res
endfunction
command! -range YankRangePath :<line1>,<line2>call YankVisualRangeWithPath()

" ビジュアル選択範囲をファイルパス:行番号形式でヤンク
" e.g.: nvim/init.vim:1493-1500
xnoremap <Space>rp :YankRangePath<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SECTION: set options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
syntax enable

set mouse=n

" システムクリップボードとの連携
" set clipboard+=unnamedplus

" fold
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
" nnoremap sf <cmd>set foldmethod=expr<CR><cmd>set foldexpr=nvim_treesitter#foldexpr()<CR>
set nofoldenable " Disable folding at startup.
set foldlevelstart=100
nnoremap Z za

" 挿入モードでのバックスペースで改行が削除できない場合に設定する項目
set backspace=indent,eol,start

" 検索した際に最後の語句の次に最初の語句にループしないようにする
set nowrapscan

autocmd FileType * set wrap
autocmd FileType neo-tree set nowrap
autocmd FileType qf set nowrap

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

" " 独自定義highlight
" highlight CursorLine ctermbg=238
" highlight CursorLine guibg=#383838
" highlight Visual cterm=bold ctermfg=NONE ctermbg=24
" highlight Visual gui=bold guifg=NONE guibg=#11607d
" " highlight StatusLine cterm=bold ctermbg=193 ctermfg=0
" " highlight StatusLineNC ctermbg=193
" highlight NonText    ctermfg=239 ctermbg=None
" highlight NonText    guifg=#3d3d3d guibg=None
" highlight SpecialKey ctermfg=239 ctermbg=None
" highlight SpecialKey guifg=#3d3d3d guibg=None
" highlight Folded ctermfg=15 ctermbg=8
" highlight Folded guifg=#fff9e6 guibg=#586358
" " highlight Search ctermfg=0 ctermbg=44
" " highlight Search guifg=#021f02 guibg=#43c5d9
" " highlight IncSearch cterm=bold ctermbg=44 ctermfg=0
" " highlight IncSearch gui=bold guifg=#021f02 guibg=#43c5d9

" " nvim-cmp
" " cui setting
" highlight! CmpItemAbbrMatch cterm=bold ctermbg=NONE ctermfg=44
" highlight! CmpItemAbbrMatchFuzzy ctermbg=NONE ctermfg=27
" " gui setting
" " gray
" highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
" " blue
" highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
" highlight! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch
" " light blue
" highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
" highlight! link CmpItemKindInterface CmpItemKindVariable
" highlight! link CmpItemKindText CmpItemKindVariable
" " pink
" highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
" highlight! link CmpItemKindMethod CmpItemKindFunction
" " front
" highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
" highlight! link CmpItemKindProperty CmpItemKindKeyword
" highlight! link CmpItemKindUnit CmpItemKindKeyword

" txtファイルで自動改行を防ぐ
" https://loumo.jp/archives/10503
autocmd FileType text :set formatoptions=q
autocmd FileType gitcommit :set formatoptions=q

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

" https://zenn.dev/vim_jp/articles/2024-10-07-vim-insert-uppercase
" <C-w> の前に関数の評価が行われる
function s:toupper_prev_word()
  let col = getpos('.')[2]
  let substring = getline('.')[0:col-1]
  let word = matchstr(substring, '\v<(\k(<)@!)*$')
  return toupper(word)
endfunction
inoremap <expr> <C-a>u "<C-w>" .. <SID>toupper_prev_word()

" 現在行の blame で得られるコミットハッシュをクリップボードにヤンクする
function! GitBlameCurrentLine()
  let l:current_line = line('.')
  let l:current_file = expand('%:p')

  " git blame コマンドを実行
  let l:command = 'git blame -L '.l:current_line.','.l:current_line.' '.shellescape(l:current_file)
  let l:result = system(l:command)

  " エラーの場合は処理を中断
  if v:shell_error != 0
    echoerr 'Error: This file is not under git management or the command failed.'
    return
  endif

  " 結果からコミットハッシュを抽出（1列目がハッシュ）
  let l:commit_hash = matchstr(l:result, '^\S\+')

  " ハッシュを表示
  let @+ = l:commit_hash
  echo 'Commit Hash copied to clipboard: '.l:commit_hash
endfunction
command! GitBlameLine call GitBlameCurrentLine()
nnoremap <Space>gh <cmd>GitBlameLine<CR>

function! s:GetGitHubRepoInfo()
  try
    " リモートリポジトリのURLを取得
    let l:remote_url = system('git config --get remote.origin.url')

    " エラーの場合は処理を中断
    if v:shell_error != 0 || l:remote_url == ''
      echoerr 'Error: Unable to retrieve the remote URL. Ensure this is a git repository.'
      return ['', '']
    endif

    " 改行を削除
    let l:remote_url = substitute(l:remote_url, '\n', '', '')
    " 末尾の .git を削除
    let l:remote_url = substitute(l:remote_url, '\.git$', '', '')

    " リモートURLを解析してユーザー名とリポジトリ名を取得
    if l:remote_url =~ '^https://github.com/'
      let l:match = matchlist(l:remote_url, 'https://github.com/\([^/]\+\)/\([^/]\+\)$')
    elseif l:remote_url =~ '^git@github.com:'
      let l:match = matchlist(l:remote_url, 'git@github.com:\([^/]\+\)/\([^/]\+\)$')
    else
      echoerr 'Error: Unsupported remote URL format.'
      return ['', '']
    endif

    " マッチ結果からユーザー名とリポジトリ名を返す
    if len(l:match) >= 3
      return [l:match[1], l:match[2]]
    else
      echoerr 'Error: Failed to parse remote URL.'
      return ['', '']
    endif
  catch
    echoerr 'An unexpected error occurred while retrieving GitHub repo info.'
    return ['', '']
  endtry
endfunction

function! GitHubSearchPR()
  try
    let l:current_line = line('.')
    let l:current_file = expand('%:p')

    " git blame コマンドを実行
    let l:command = 'git blame -L '.l:current_line.','.l:current_line.' '.shellescape(l:current_file)
    let l:result = system(l:command)

    " エラーの場合は処理を中断
    if v:shell_error != 0
      echoerr 'Error: This file is not under git management or the command failed.'
      return
    endif

    " 結果からコミットハッシュを抽出
    let l:commit_hash = matchstr(l:result, '^\S\+')

    " GitHub リポジトリ情報を取得
    let l:repo_info = s:GetGitHubRepoInfo()
    let l:github_user = l:repo_info[0]
    let l:github_repo = l:repo_info[1]

    " ユーザー名またはリポジトリ名が取得できない場合
    if l:github_user == '' || l:github_repo == ''
      echoerr 'Error: Could not determine GitHub repository info.'
      return
    endif

    " PR 検索用の URL を作成
    let l:github_url = 'https://github.com/'.l:github_user.'/'.l:github_repo.'/pulls?q='.l:commit_hash
    echo 'GitHub PR Search URL: '.l:github_url
    let @+ = l:github_url
    echo 'URL copied to clipboard: '.l:github_url

    " confirm を使用してブラウザで開くか確認
    if confirm('Open in browser? -> '.l:github_url, "&Yes\n&No", 1) == 1
      call system('xdg-open '.shellescape(l:github_url))
      echo 'Opening in browser...'
      if has('mac') || has('macunix')
          call system('open '.shellescape(l:github_url))
      elseif has('unix')
          call system('xdg-open '.shellescape(l:github_url))
      elseif has('win32') || has('win64')
          call system('start '.shellescape(l:github_url))
      else
          echoerr 'Error: Unable to detect platform for opening URL.'
      endif
    endif
  catch
    echoerr 'An unexpected error occurred.'
  endtry
endfunction
command! GitHubSearchPR call GitHubSearchPR()

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" マッピング方針
"
" nmap
" - s, S は潰す
" - x だけはブラックホールレジスタを使うようにする
" - t はタブ関係で潰す
" - , と ; も潰す
" - H, L, M は迷いなく潰す
" - J, K は潰す、K は戻したい気持ちもある
" - m は潰す
" - n, N は検索プラグインに委譲する
" - q はなるべく残すが Q は積極的に潰す
" - Z は git commit 時のみの特殊用途に潰している
" - C-b,f,d,u,e,y は積極的に潰したいが、d,u のみはデフォルトを維持している
" - C-g はこのままなるべくデフォルトを維持したい
" - C-h,j,k,l は l のみは手動で潰さないようにする
" - C-n は遠慮なく潰してよい、C-p は fuzzy finder で固定する
" - C-i,o は元のジャンプ機能を維持しつつカスタマイズする
" - C-m は <CR> を潰してよいなら好きに潰せる
" - C-q,s は terminal 関係で潰すが、使用する端末によってはマップが有効化されない可能性がある
" - C-t はタグを使わないなら潰しても良いが、tmux との併用がしづらいのでこのままにする
" - C-w は謎だが触れない方が良い
" - C-z は触らない
"
" imap
" - C-a は自由に潰す
" - C-c は潰してもよいが、そのままにしておく
" - C-d,t はインデントに便利なので、デフォルトを維持する
" - C-e,y は自由に潰してよいが、LSP 系で潰されているのかもしれない
" - C-g はちょっと謎なのでデフォルトを維持したい
" - C-h は…
" - C-i は Tab もマップされてしまうため、デフォルト維持を厳守する
" - C-j は必ず skk に提供する
" - C-m は <CR> と等価であるため、デフォルト維持を厳守する
" - C-k は digraph 入力用に残しておきたい
" - C-l,z は潰しても良い
" - C-n,p,x はデフォルトでは補完機能なので残しておきたいが、実際はそうは出来ていない
" - C-o はデフォルトを維持する
" - C-q,v は文字コードを指定して文字を入力するものなので、なるべくデフォルトを維持する
" - C-r はもともとの機能を拡張する範囲でしかいじらないこと
" - C-s は端末によっては使えないので、触らない
" - C-u はデフォルトを維持する
" - C-w はデフォルトを維持する
" - C-[ は ESC なので、絶対にデフォルトを維持する
" - C-] は潰しても良さそう
"
" cmap
" - C-a は自由に潰す
" - C-b,e は潰しても良いが、デフォルトを維持する
" - C-c は潰してもよいが、そのままにしておく
" - C-d は補完関連であるため、デフォルトを維持する
" - C-f はコマンドラインウィンドウを開けて便利であるため、デフォルトを維持する
" - C-g,t は潰しても良さそう
" - C-h,l は…
" - C-j は必ず skk に提供する
" - C-i,m はそれぞれ TAB, CR であるため、必ずデフォルトを維持する
" - C-k はデフォルトを維持する
" - C-n,p はデフォルトを維持する
" - C-q,v はデフォルトを維持する
" - C-r はもともとの機能を拡張する範囲でしかいじらないこと
" - C-s はデフォルトを維持する
" - C-u はデフォルトを維持する
" - C-w はデフォルトを維持する
"
" ref: https://files.kaoriya.net/docs/SpartanVim/SpartanVim-5.1-online.pdf
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" esc
inoremap <silent> jj <ESC> " better-escapeプラグインに委譲

" prefix
nnoremap s <Nop>
nnoremap t <Nop>
" nnoremap q <Nop>
nnoremap <Space> <Nop>

" command line window
" nnoremap <Space>q q:
" nnoremap <Space>/ q/
set cmdwinheight=20

" cursor move
nnoremap j gj
nnoremap k gk
inoremap <C-h> <Left>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
nnoremap J 10gj
nnoremap K 10gk
vnoremap J 10gj
vnoremap K 10gk
nnoremap H ^
vnoremap H ^
nnoremap L $
vnoremap L $

" search
" nzz, Nzz は、現在 lua プラグインに寄せている
" nnoremap n nzz
" nnoremap N Nzz
nnoremap <ESC><ESC> <cmd>nohlsearch<CR>

" window
nnoremap s- <cmd>split<CR>
nnoremap s<Bar> <cmd>vsplit<CR>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap s= <C-w>=
" nnoremap so <C-w>_<C-w>|
" nnoremap sO <C-w>=
nnoremap sq <cmd>confirm quit<CR>
nnoremap sQ <cmd>confirm qall<CR>

" tab
nnoremap tq <cmd>tabclose<CR>

" buffer
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz

" customize zz
" ref: https://zenn.dev/vim_jp/articles/67ec77641af3f2
nmap zz zz<sid>(z1)
nnoremap <script> <sid>(z1)z zt<sid>(z2)
nnoremap <script> <sid>(z2)z zb<sid>(z3)
nnoremap <script> <sid>(z3)z zz<sid>(z1)

" save, load
nnoremap <Space>w <cmd>write<CR>
nnoremap <Space>e <cmd>edit!<CR>

" yank, paste
vmap <Space>y "+y
vmap <Space>p "+p
vmap <Space>P "+P
nmap <Space>y "+y
nmap <Space>p "+p
nmap <Space>P "+P
nnoremap Y ggVG"+y

" blackhole register
nnoremap x "_x

" register(insert a register's content)
inoremap <C-r><C-r> <C-r>"
inoremap <C-r>r <C-r>"
cnoremap <C-r><C-r> <C-r>"
cnoremap <C-r>r <C-r>"
inoremap <C-r><Space> <C-r>+
cnoremap <C-r><Space> <C-r>+

" blackhole and clipboadrd register
" ref: https://blog.atusy.net/2025/08/08/map-minus-to-blackhole-register/
nnoremap - "_
xnoremap - "_
nnoremap + "+
xnoremap + "+

" for browsing the input history
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" toggle
nnoremap <Space>n <cmd>set number!<CR>
nnoremap <Space><Space> <cmd>set wrap!<CR>
command! ToggleColorColumn call ToggleColorColumn()

" 120 文字ガイドのトグル
function! ToggleColorColumn()
    if &colorcolumn == ''
        execute "set colorcolumn=" . join(range(121, 9999), ',')
    else
        set colorcolumn=
    endif
endfunction

set nonumber
" フォーカス中のwindowでのみ行番号を表示する
" augroup vimrc-auto-number
"   autocmd!
"   autocmd WinEnter * setlocal number
"   autocmd WinLeave * setlocal nonumber
" augroup END

augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

" help-curwin
command -bar -nargs=? -complete=help H execute s:HelpCurwin(<q-args>)
let s:did_open_help = v:false

function s:HelpCurwin(subject) abort
  let mods = 'silent noautocmd keepalt'
  if !s:did_open_help
    execute mods .. ' help'
    execute mods .. ' helpclose'
    let s:did_open_help = v:true
  endif
  " ヘルプのままだとneovimではエラーになる
  " ref: https://github.com/neovim/neovim/issues/14847
  " if !getcompletion(a:subject, 'help')->empty()
  if !empty(getcompletion(a:subject, 'help'))
    execute mods .. ' edit ' .. &helpfile
    set buftype=help
  endif
  return 'help ' .. a:subject
endfunction

" 文字コードによる入力
inoremap <C-v>u <C-r>=nr2char(0x)<Left>

" マッチ行をすべてデフォルトレジスタとクリップボードにヤンクする
command! -nargs=? YankMatches call YankMatches(<f-args>)
function! YankMatches(...) abort
  let @" = ''
  let @+ = ''
  let l:count = 0

  if a:0 >= 1 && !empty(a:1)
    " パターンが明示された場合
    execute 'g/' . escape(a:1, '/\') . '/let @" .= getline(".") . "\n" | let @+ .= getline(".") . "\n" | let l:count += 1'
  else
    " 現在の検索パターンを使用（@/）
    execute 'g//let @" .= getline(".") . "\n" | let @+ .= getline(".") . "\n" | let l:count += 1'
  endif

  echo 'Yanked' l:count 'lines to default register and clipboard'
endfunction

" 使い捨てのバッファを作るコマンド、nvim 単体で呼び出したときも使い捨てのバッファから始める
autocmd VimEnter * if argc() == 0 | enew | setlocal buftype=nofile bufhidden=wipe noswapfile | endif
command! Scratch 10split |  enew | setlocal buftype=nofile bufhidden=wipe noswapfile
nnoremap S :Scratch<CR>

" editprompt 専用の map
autocmd BufRead,BufNewFile .editprompt-* set filetype=editprompt
autocmd FileType editprompt nnoremap <buffer> <CR> <cmd>wq<CR>
