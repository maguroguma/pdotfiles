
" ctrlp.vim
" nmap <Leader>f :CtrlP<CR>
" let g:ctrlp_cmd = 'CtrlPBuffer'

" fzf
" [Replace of ctrlp.vim] ========================================
" nnoremap <C-p> :FZFFileList(1/2)<CR>
" command! FZFFileList(2/2) call fzf#run({
"             \ 'source': 'find . -type d -name .git -prune -o ! -name .DS_Store',
"             \ 'sink': 'e'})

" [MRU] ========================================
command! Fmru FZFMru
" command! FZFMru call fzf#run({
"             \  'source':  v:oldfiles,
"             \  'sink':    'tabe',
"             \  'options': '-m -x +s',
"             \  'down':    '40%'})
command! FZFMru call fzf#run({
            \  'source':  v:oldfiles,
            \  'sink':    'e',
            \  'options': '-m -x +s',
            \  'down':    '40%'})

"ctrlP"{{{
" if executable('rg')
"   let g:ctrlp_user_command = 'rg --files %s'
"   let g:ctrlp_use_caching = 0
"   let g:ctrlp_working_path_mode = 'ra'
"   let g:ctrlp_switch_buffer = 'et'
" endif

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

" if executable('rg')
"   call denite#custom#var('file_rec', 'command',
"         \ ['rg', '--files', '--glob', '!.git'])
"   call denite#custom#var('grep', 'command', ['rg'])
" endif

nnoremap <silent> <C-p> :Files<CR>
" nnoremap <silent> <C-p><C-p> :Files<CR>
" nnoremap <silent> <C-p>p :Files<CR>
" nnoremap <silent> <C-p><C-m> :Fmru<CR>
" nnoremap <silent> <C-p>m :Fmru<CR>
" nnoremap <silent> <C-p><C-b> :Buffers<CR>
" nnoremap <silent> <C-p>b :Buffers<CR>
" nnoremap <silent> <C-p>gr :Rg!<CR>

nnoremap <silent> ; :Buffers<CR>

" nnoremap <silent> ,f :GFiles<CR>
" nnoremap <silent> ,F :GFiles?<CR>
" nnoremap <silent> ,l :BLines<CR>
" nnoremap <silent> ,h :History<CR>
" nnoremap <silent> ,m :Mark<CR>

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

" Insert mode completion
" imap <c-x><c-k> <plug>(fzf-complete-word)
" imap <c-x><c-f> <plug>(fzf-complete-path)
" imap <c-x><c-j> <plug>(fzf-complete-file-ag)
" imap <c-x><c-l> <plug>(fzf-complete-line)

" Advanced customization using Vim function
" inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

" imap <C-A>k <plug>(fzf-complete-word)
" imap <C-A>f <plug>(fzf-complete-path)
" imap <C-A>j <plug>(fzf-complete-file-ag)
" imap <C-A>l <plug>(fzf-complete-line)

" popup window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" basic layout
" let g:fzf_layout = { 'down': '50%' }

" telescope.nvim
" Find files using Telescope command-line sugar.
" nnoremap <C-p> <cmd>Telescope find_files<cr>
" nnoremap <leader>fg <cmd>Telescope live_grep<cr>
" nnoremap ; <cmd>Telescope buffers<cr>
" nnoremap <leader>fh <cmd>Telescope help_tags<cr>

