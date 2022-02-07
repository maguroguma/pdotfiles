" nmap gs <plug>(GrepperOperator)
" xmap gs <plug>(GrepperOperator)

" nnoremap <leader>gg :Grepper -tool git<cr>
" nnoremap <leader>ga :Grepper -tool ag<cr>
" nnoremap <leader>gs :Grepper -tool ag -side<cr>
" nnoremap <leader>*  :Grepper -tool ag -cword -noprompt<cr>

" rgが好きなので
nnoremap <leader>gr :Grepper -tool rg<cr>
nnoremap <leader>gw :Grepper -tool rg -cword -noprompt<cr>

" let g:grepper = {}
" let g:grepper.tools = ['git', 'ag', 'grep']
" let g:grepper.open = 0
" let g:grepper.jump = 1
" let g:grepper.prompt_mapping_tool = '<leader>g'

" command! Todo Grepper -noprompt -tool git -query -E '(TODO|FIXME|XXX):'

"""
" ctrlsf
"
" previewウィンドウでの重要操作
" Enter: previewを閉じて、起動したウィンドウにファイルをオープン
" O: previewを開いたまま、起動したウィンドウにファイルをオープン
" <C-j,n,k,p>: マッチの前後移動
" <C-t>: fzfを呼び出してファジーマッチした行にpreview上を移動
" q: previewを閉じる
"""
" options
let g:ctrlsf_search_mode = 'async'
let g:ctrlsf_position = 'right'
" let g:ctrlsf_winsize = '30%'
" let g:ctrlsf_regex_pattern = 1
" let g:ctrlsf_fold_result = 1
let g:ctrlsf_auto_focus = {
    \ "at": "start"
    \ }

" map
nmap     <C-g>g <Plug>CtrlSFPrompt
" vmap     <C-g>f <Plug>CtrlSFVwordPath
vmap     <C-g>g <Plug>CtrlSFVwordExec
nmap     <C-g>w <Plug>CtrlSFCwordPath
nmap     <C-g>p <Plug>CtrlSFPwordPath
nnoremap <C-g>o :CtrlSFOpen<CR>
nnoremap <C-g>t :CtrlSFToggle<CR>
inoremap <C-g>t <Esc>:CtrlSFToggle<CR>
" map(ctrl)
nmap     <C-g><C-g> <Plug>CtrlSFPrompt
vmap     <C-g><C-g> <Plug>CtrlSFVwordExec
nmap     <C-g><C-w> <Plug>CtrlSFCwordPath
nmap     <C-g><C-p> <Plug>CtrlSFPwordPath
nnoremap <C-g><C-o> :CtrlSFOpen<CR>
nnoremap <C-g><C-t> :CtrlSFToggle<CR>
inoremap <C-g><C-t> <Esc>:CtrlSFToggle<CR>
" original
nnoremap <leader>gc :CtrlSF -R 

"""
" vimgrep
"""
" vim grepすると自動的にあたらしいウィンドウで検索結果一覧を表示する
autocmd QuickFixCmdPost *grep* cwindow
