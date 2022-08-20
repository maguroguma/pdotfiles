"""
" PLUGSETTING: junegunn/fzf.vim
"""

command! Fmru FZFMru
command! FZFMru call fzf#run({
            \  'source':  v:oldfiles,
            \  'sink':    'e',
            \  'options': '-m -x +s',
            \  'down':    '40%'})

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ripgrep with vim
" http://hogeai.hatenablog.com/entry/2018/03/04/201744
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" fzf
" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-m> :Fmru<CR>
nnoremap <silent> ; :Buffers<CR>

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(
    \   <q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}),
    \   <bang>0)

command! -bang -nargs=? -complete=dir Buffers
    \ call fzf#vim#buffers(
    \   <q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}),
    \   <bang>0)

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" popup window
let g:fzf_layout = { 'window': { 'width': 0.5, 'height': 0.4, 'yoffset': 0.5 } }

" Empty value to disable preview window altogether
let g:fzf_preview_window = []

" https://github.com/junegunn/fzf.vim/pull/733#issuecomment-559720813
function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))
