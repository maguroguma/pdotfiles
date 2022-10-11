"""
" PLUGSETTING: junegunn/fzf.vim
"""

"""
" commands
"""

" ripgrep with vim
" http://hogeai.hatenablog.com/entry/2018/03/04/201744
if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

command! Fmru FZFMru
command! FZFMru call fzf#run({
            \  'source':  v:oldfiles,
            \  'sink':    'e',
            \  'options': '-m -x +s',
            \  'down':    '40%'})

" fzf
" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

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
" custom git show with fugitive.vim
"""
" source
function! s:list_commits() abort
  let l:res = system('git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --color=always')
  return split(l:res, "\n")
endfunction
" sink
function! s:select_commits(commit_hash) abort
  let l:list = split(a:commit_hash, ' ')
  let l:execute_command = 'Git show ' . l:list[1] . ':%'
  execute l:execute_command
endfunction
command! GShow call fzf#run(fzf#wrap({
  \ 'source': s:list_commits(),
  \ 'sink': funcref('s:select_commits'),
  \ 'options': '--ansi --prompt "git show of the buffer> "',
\ }))

"""
" layouts, styles
"""

" popup window
let g:fzf_layout = { 'window': { 'width': 0.5, 'height': 0.4, 'yoffset': 0.5 } }

" Empty value to disable preview window altogether
let g:fzf_preview_window = []

"""
" maps
"""

" Snippets, Commits, BCommits, Commands
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-m> :History<CR>
nnoremap <silent> ; :Buffers<CR>
nnoremap <silent> , :Marks<CR>
nnoremap <silent> <leader>h :Helptags<CR>
nnoremap <silent> <leader>gf :GFiles?<CR>
nnoremap <silent> <leader>Q :History:<CR>
nnoremap <silent> <leader>gs :GShow<CR>
nnoremap <silent> <leader>bd :BD<CR>

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
imap <C-a><tab> <plug>(fzf-maps-i)
