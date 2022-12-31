"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SECTION: initialize
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

if exists('g:loaded_maguroguma_nvim_setting')
  finish
endif
let g:loaded_maguroguma_nvim_setting = 1

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
call jetpack#load_toml(expand('$HOME/.config/nvim/dein.toml'))
call jetpack#add('nathom/filetype.nvim')

" common library
call jetpack#add('vim-denops/denops.vim')
call jetpack#add('nvim-lua/plenary.nvim')
call jetpack#add('Shougo/vimproc.vim', { 'build' : 'make' })
call jetpack#add('vim-jp/vital.vim')

call jetpack#add('vim-jp/vimdoc-ja')
call jetpack#add('segeljakt/vim-silicon') " code snapshot tool helper (DO NOT lazy load)
call jetpack#add('hotwatermorning/auto-git-diff') " show git diff
call jetpack#add('lambdalisue/readablefold.vim')
call jetpack#add('mtdl9/vim-log-highlighting')
call jetpack#add('Yggdroot/indentLine')
call jetpack#add('tpope/vim-repeat')
call jetpack#add('ryanoasis/vim-devicons')
call jetpack#add('mattn/vim-sonictemplate') " (DO NOT lazy load)
call jetpack#add('editorconfig/editorconfig-vim')
call jetpack#add('machakann/vim-sandwich')
call jetpack#add('luochen1990/rainbow')
call jetpack#add('ntpeters/vim-better-whitespace')
call jetpack#add('sirver/ultisnips') " require coc-ultisnips if used with coc.nvim
call jetpack#add('haya14busa/vim-asterisk') " better asterisk behavior
call jetpack#add('t9md/vim-quickhl') " mark colors to words and sentences
call jetpack#add('machakann/vim-highlightedyank')
call jetpack#add('markonm/traces.vim') " realize live substitute
call jetpack#add('tyru/open-browser.vim')
call jetpack#add('tyru/open-browser-github.vim')
call jetpack#add('vim-scripts/autodate.vim') " add automatic updating date format
call jetpack#add('w0ng/vim-hybrid') " vim theme
call jetpack#add('srcery-colors/srcery-vim') " vim theme
call jetpack#add('ruanyl/vim-gh-line')
call jetpack#add('monaqa/modesearch.vim')
call jetpack#add('thinca/vim-partedit') " (DO NOT lazy load)
call jetpack#add('previm/previm') " (DO NOT lazy load)

" lua plugin
call jetpack#add('kevinhwang91/nvim-bqf')
call jetpack#add('nvim-lualine/lualine.nvim')

" coc-setting.vim
call jetpack#add('neoclide/coc.nvim', { 'branch': 'release' })

" nvim-cmp
call jetpack#add('hrsh7th/cmp-buffer')
call jetpack#add('hrsh7th/cmp-path')
call jetpack#add('hrsh7th/cmp-cmdline')
call jetpack#add('hrsh7th/nvim-cmp')
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

nnoremap <silent> <Space>lg :LazyGit<CR>

let g:sonictemplate_vim_template_dir = [
      \ expand('$GOPATH') . '/src/github.com/maguroguma/go-competitive/template',
      \ expand('$DOTFILES_DIR') . '/nvim/sonic-template',
      \]

let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

let g:highlightedyank_highlight_duration = 500

let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

let g:better_whitespace_filetypes_blacklist = ['diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'fugitive', 'defx']
let g:better_whitespace_ctermcolor = '12'

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

let g:UltiSnipsExpandTrigger = '<c-j>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:UltiSnipsEditSplit = 'vertical'
" let g:UltiSnipsSnippetDirectories = ['']

noremap <Space>u :UndotreeToggle<CR>

nnoremap <C-s> <Cmd>FloatermToggle<CR>

nmap g/ <Plug>(modesearch-slash)
nmap g? <Plug>(modesearch-question)
cmap <C-x> <Plug>(modesearch-toggle-mode)

let g:partedit#auto_prefix = v:false

nmap <C-e> <cmd>WinResizerStartResize<CR>

nnoremap <silent> <Space>mp <cmd>PrevimOpen<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SECTION: neoclide/coc.nvim
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

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

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
nnoremap <silent> gh :call ShowDocumentation()<CR>

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
" xmap <Space>f  <Plug>(coc-format-selected)
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
" xmap <Space>a  <Plug>(coc-codeaction-selected)
" nmap <Space>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
" nmap <Space>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
" nmap <Space>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
" nmap <Space>cl  <Plug>(coc-codelens-action)

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
highlight CocMenuSel ctermbg=53 guibg=#082A4B cterm=BOLD
highlight CocSearch ctermfg=184 guifg=#18A3FF

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
      \ 'coc-json',
      \ 'coc-prettier',
      \ 'coc-python',
      \ 'coc-tsserver',
      \ 'coc-ultisnips',
      \ 'coc-vetur',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-yaml',
      \ 'coc-sh',
      \ 'coc-word',
      \ 'coc-syntax',
      \ 'coc-docker',
      \ 'coc-tailwindcss',
      \ 'coc-deno',
      \ 'coc-fzf-preview',
      \ 'coc-vimlsp',
      \ ]

" fzf-preview
let g:fzf_preview_floating_window_rate = 0.9

"""
" node path
"""
" let g:coc_node_path = '/path/to/node'

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
  redir @z | echo strftime("%Y-%m-%d") | redir END
  norm "zp
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

" https://zenn.dev/uochan/articles/2021-12-08-vim-conventional-commits
function! s:select_type() abort
  let line = substitute(getline('.'), '^#\s*', '', 'g')
  let title = printf('%s: ', split(line, ' ')[0])

  silent! normal! "_dip
  silent! put! =title
  silent! startinsert!
endfunction
autocmd FileType gitcommit nnoremap <buffer> <C-m><C-m> <Cmd>call <SID>select_type()<CR>

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

" vimgrep
" vim grepすると自動的にあたらしいウィンドウで検索結果一覧を表示する
autocmd QuickFixCmdPost *grep* cwindow

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
if getftype(expand('$HOME') . '/.zhistory') != ""
  function! s:showShellHistory(...)
    execute 'botright' 10 'new'
    setlocal nobuflisted bufhidden=unload buftype=nofile
    silent read !cat $HOME/.zhistory | cut -b 16- | head -n 5000
    " silent read !cat $HOME/.zhistory |
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
highlight Search cterm=bold ctermbg=50 ctermfg=0
highlight Folded ctermbg=Green ctermfg=Gray

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

set shell=/bin/zsh
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

" macro
" nnoremap Q q

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lua scripts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set completeopt=menu,menuone,noselect

nmap <Space>a <cmd>AerialToggle<CR>

" jetpack利用時は先頭に追加するようにする
set runtimepath^=~/.local/share/nvim/site/pack/jetpack/nvim-treesitter

"""
" PLUGSETTING: rlane/pounce.nvim
"""
nmap ' <cmd>Pounce<CR>
vmap ' <cmd>Pounce<CR>
omap g' <cmd>Pounce<CR>

lua << EOF
-- Set up nvim-cmp.
local cmp = require'cmp'

local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

cmp.setup {
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      -- Source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[LaTeX]",
      })[entry.source.name]
      return vim_item
    end
  },
}

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   },
--   view = {
--     entries = {name = 'custom', selection_order = 'near_cursor' }
--   },
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  view = {
    entries = {name = 'custom', selection_order = 'near_cursor' }
  },
})

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
