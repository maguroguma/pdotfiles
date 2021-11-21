" for browsing the input history
cnoremap <c-n> <down>
cnoremap <c-p> <up>

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
"""
nnoremap <leader>gc :CtrlSF -R
let g:ctrlsf_search_mode = 'async'
let g:ctrlsf_position = 'right'
" let g:ctrlsf_winsize = '30%'

"""
" vimgrep
"""
" vim grepすると自動的にあたらしいウィンドウで検索結果一覧を表示する
autocmd QuickFixCmdPost *grep* cwindow
