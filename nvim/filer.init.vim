"" nerdtree
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 30
let NERDTreeShowHidden=1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
nnoremap <Leader>n :NERDTreeTabsToggle<CR>

" nerdtree
" ファイル指定しないときはnerdtreeを開く
" if !argc()
"     autocmd vimenter * NERDTree
"     let g:nerdtree_tabs_open_on_console_startup = 1
" endif

" nerdtreeのラグ改善
let g:NERDTreeLimitedSyntax = 1
