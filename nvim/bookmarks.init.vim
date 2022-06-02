" MattesGroeger/vim-bookmarks
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1

" カスタムキーマップ
let g:bookmark_no_default_key_mappings = 1
nmap <Leader>mm <Plug>BookmarkToggle
nmap <Leader>mi <Plug>BookmarkAnnotate
" nmap <Leader>mn <Plug>BookmarkNext
" nmap <Leader>mp <Plug>BookmarkPrev
nmap <Leader>ma <Plug>BookmarkShowAll
nmap <Leader>mc <Plug>BookmarkClear
nmap <Leader>mx <Plug>BookmarkClearAll
nmap <Leader>mkk <Plug>BookmarkMoveUp
nmap <Leader>mjj <Plug>BookmarkMoveDown
nmap <Leader>mg <Plug>BookmarkMoveToLine
