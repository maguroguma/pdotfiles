"""
" PLUGSETTING: tpope/vim-fugitive
"""
nnoremap <Leader>gd :Git diff %<CR>
nnoremap <Leader>gb :Git blame<CR>
command! Gblame :Git blame

"""
" PLUGSETTING: kdheepak/lazygit.nvim
"""
nnoremap <silent> <Leader>gl :LazyGit<CR>
nnoremap <silent> <Leader>lg :LazyGit<CR>

"""
" PLUGSETTING: junegunn/vim-easy-align
"""
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"""
" PLUGSETTING: mattn/emmet-vim
"""
let g:user_emmet_leader_key='<C-e>'

"""
" PLUGSETTING: luochen1990/rainbow
"""
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

"""
" PLUGSETTING: machakann/vim-highlightedyank
"""
let g:highlightedyank_highlight_duration = 500

"""
" PLUGSETTING: tryu/open-browser.vim
"""
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

"""
" PLUGSETTING: ntpeters/vim-better-whitespace
"""
let g:better_whitespace_filetypes_blacklist = ['diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'fugitive', 'defx']
let g:better_whitespace_ctermcolor = '195'

"""
" PLUGSETTING: junegunn/goyo.vim
"""
let g:goyo_width = 120

"""
" PLUGSETTING: tpope/vim-surround
"""
" https://rcmdnk.com/blog/2014/05/03/computer-vim-octopress/
xmap <Leader>B S*gvS*
xmap <Leader>b S*gvS*gvS<Space><Space>

"""
" PLUGSETTING: haya14busa/vim-asterisk
"""
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)

"""
" PLUGSETTING: kkoomen/vim-doge
"""
let g:doge_enable_mappings = 0

"""
" PLUGSETTING: t9md/vim-quickhl
"""
nmap M <Plug>(quickhl-manual-this)
xmap M <Plug>(quickhl-manual-this)

"""
" PLUGSETTING: windwp/nvim-spectre
"""
nnoremap <leader>s <cmd>lua require('spectre').open()<CR>
vnoremap <leader>s <cmd>lua require('spectre').open_visual()<CR>

"""
" PLUGSETTING: monaqa/dial.nvim
"""
nmap  <C-a>  <Plug>(dial-increment)
nmap  <C-x>  <Plug>(dial-decrement)
vmap  <C-a>  <Plug>(dial-increment)
vmap  <C-x>  <Plug>(dial-decrement)
vmap g<C-a> g<Plug>(dial-increment)
vmap g<C-x> g<Plug>(dial-decrement)

"""
" PLUGSETTING: ruanyl/vim-gh-line
"""
let g:gh_line_map_default = 0
let g:gh_line_blame_map_default = 0
let g:gh_line_map = '<leader>gh'

"""
" PLUGSETTING: vim-scripts/autodate.vim
"""
" フォーマット
let autodate_format="%Y-%m-%d %H:%M:%S"
" タグの挿入コマンド
inoremap <C-a>lc Last Change: 2022-08-14 17:06:15.

"""
" PLUGSETTING: MattesGroeger/vim-bookmarks
"""
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1

" カスタムキーマップ
let g:bookmark_no_default_key_mappings = 1
nmap <Leader>mm <Plug>BookmarkToggle
nmap <Leader>mi <Plug>BookmarkAnnotate
nmap <Leader>ma <Plug>BookmarkShowAll
nmap <Leader>mc <Plug>BookmarkClear
nmap <Leader>mx <Plug>BookmarkClearAll
nmap <Leader>mkk <Plug>BookmarkMoveUp
nmap <Leader>mjj <Plug>BookmarkMoveDown
nmap <Leader>mg <Plug>BookmarkMoveToLine

"""
" PLUGSETTING: moll/vim-bbye
"""
nnoremap <Leader>d <C-u>:Bdelete<CR>
nnoremap <Leader>D <C-u>:bufdo :Bdelete<CR>

"""
" PLUGSETTING: t9md/vim-choosewin
"""
nmap ss <Plug>(choosewin)
" オーバーレイ機能を有効にしたい場合
let g:choosewin_overlay_enable          = 1
" オーバーレイ・フォントをマルチバイト文字を含むバッファでも綺麗に表示する。
let g:choosewin_overlay_clear_multibyte = 1

"""
" PLUGSETTING: mhinz/vim-grepper
"""
nnoremap <leader>gr :Grepper -tool rg<cr>
nnoremap <leader>gw :Grepper -tool rg -cword -noprompt<cr>

"""
" PLUGSETTING: heavenshell/vim-jsdoc
"""
let g:jsdoc_formatter = 'tsdoc'

"""
" PLUGSETTING: previm/previm
"""
nnoremap <silent> <Leader>mp :<C-u>PrevimOpen<CR>

"""
" PLUGSETTING: glidenote/memolist.vim
"""
let g:memolist_path = "~/go/src/github.com/maguroguma/memolist"
nnoremap <Leader>mn  :MemoNew<CR>
nnoremap <Leader>ml  :MemoList<CR>
nnoremap <Leader>mg  :MemoGrep<CR>

" suffix type (default markdown)
let g:memolist_memo_suffix = "md"

" date format (default %Y-%m-%d %H:%M)
let g:memolist_memo_date = "%Y-%m-%d %H:%M"

" tags prompt (default 0)
let g:memolist_prompt_tags = 1

" categories prompt (default 0)
let g:memolist_prompt_categories = 1

" use fzf (default 0)
let g:memolist_fzf = 1

"""
" PLUGSETTING: thinca/vim-quickrun
"""
" https://besier.hatenadiary.org/entry/20140605/1401961885
" 一時ファイルを作成
" nnoremap ,ot :e `tempname()`<CR>

" quickrun.vim
" nnoremap <silent> ,vb :QuickRun -type vim<CR>
" nnoremap <silent> ,vn :QuickRun -type vim -outputter null<CR>
" vnoremap <silent> ,vb :QuickRun -type vim<CR>
" vnoremap <silent> ,vn :QuickRun -type vim -outputter null<CR>

" https://qiita.com/844196/items/879db6528999ccf470b8
" :QuickRun json
" :'<,'>QuickRun json                 " 矩形選択中の部分を整形したい場合
" :QuickRun json -cmdopt '.hoge.fuga' " jqに引数を渡したい場合 (デフォルトは↑で設定した'.')
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config.json = {
    \ 'outputter/buffer/filetype': 'json',
    \ 'command': 'jq',
    \ 'cmdopt': '.',
    \ 'exec': 'cat %s | %c %o',
    \ }

"""
" PLUGSETTING: w0ng/vim-hybrid
"""
set background=dark
colorscheme hybrid

"""
" PLUGSETTING: sirver/ultisnips
"""
" let g:UltiSnipsExpandTrigger='<c-l>'
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'
let g:UltiSnipsEditSplit='vertical'

"""
" PLUGSETTING: mbbill/undotree
"""
" if has("persistent_undo")
"    " ファイルを閉じてもUndo記録を残す
"     set undodir=$XDG_CACHE_HOME/undodir/
"     set undofile
" endif
let g:undotree_WindowLayout = 2         " undotreeは左側/diffは下にウィンドウ幅で表示
let g:undotree_ShortIndicators = 1      " 時間単位は短く表示
let g:undotree_SplitWidth = 40          " undotreeのウィンドウ幅
let g:undotree_SetFocusWhenToggle = 1   " undotreeを開いたらフォーカスする
"let g:undotree_DiffAutoOpen = 0         " diffウィンドウは起動時無効
let g:undotree_DiffpanelHeight = 8      " diffウィンドウの行数
"let g:undotree_HighlightChangedText = 0 " 変更箇所のハイライト無効
" undotreeをトグル表示
noremap <Leader>u :UndotreeToggle<CR>

" undotreeバッファ内でのキーバインド設定
function! g:Undotree_CustomMap()
    map <silent> <buffer> <Esc> q
    map <silent> <buffer> h ?
endfunction

"""
" PLUGSETTING: voldikss/vim-floaterm
"""

" 参考: https://github.com/yutkat/dotfiles/blob/28e8df61c39727fa85d3f289343eb60feffd29d8/.config/nvim/rc/pluginconfig/vim-floaterm.vim

let g:floaterm_height = 0.95
let g:floaterm_width = 0.95

nnoremap <C-s> <Cmd>FloatermToggle<CR>
augroup vimrc_floaterm
  autocmd!
  autocmd User FloatermOpen tnoremap <buffer> <silent> <C-s> <C-\><C-n>:FloatermToggle<CR>
  autocmd QuitPre * FloatermKill!
augroup END
