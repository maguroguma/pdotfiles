" ノーマルモードへの移行
tnoremap <C-z> <C-\><C-n>

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

" 参考: https://github.com/yutkat/dotfiles/blob/28e8df61c39727fa85d3f289343eb60feffd29d8/.config/nvim/rc/pluginconfig/vim-floaterm.vim

let g:floaterm_height = 0.95
let g:floaterm_width = 0.95

""" original
" nnoremap <terminal>   <Nop>
" nmap    m <terminal>
" nnoremap <terminal>  <Cmd>FloatermToggle<CR>
" nnoremap <terminal>m <Cmd>FloatermToggle<CR>
" nnoremap <terminal>a <Cmd>FloatermNew<CR>
" nnoremap <terminal>p <Cmd>FloatermPrev<CR>
" nnoremap <terminal>n <Cmd>FloatermNext<CR>
" nnoremap <terminal>l <Cmd>FloatermLast<CR>
"       nnoremap <silent>   <F7>    :FloatermNew<CR>
"       tnoremap <silent>   <F7>    <C-\><C-n>:FloatermNew<CR>
"       nnoremap <silent>   <F8>    :FloatermPrev<CR>
"       tnoremap <silent>   <F8>    <C-\><C-n>:FloatermPrev<CR>
"       nnoremap <silent>   <F9>    :FloatermNext<CR>
"       tnoremap <silent>   <F9>    <C-\><C-n>:FloatermNext<CR>
" command! Wqa execute ':FloatermKill!' | wqa
" cnoreabbrev wqa Wqa
" augroup vimrc_floaterm
"   autocmd!
"   autocmd User FloatermOpen nnoremap <buffer> <silent> <Esc> <Cmd>FloatermToggle<CR>
"   autocmd User FloatermOpen tnoremap <buffer> <silent> m <C-\><C-n>:FloatermToggle<CR>
"   autocmd User FloatermOpen tnoremap <buffer> <silent> <F1> <C-\><C-n>:FloatermNew<CR>
"   autocmd User FloatermOpen tnoremap <buffer> <silent> <F2> <C-\><C-n>:FloatermPrev<CR>
"   autocmd User FloatermOpen tnoremap <buffer> <silent> <F3> <C-\><C-n>:FloatermNext<CR>
"   autocmd QuitPre * FloatermKill!
" augroup END

""" Arrange
nnoremap <C-s> <Cmd>FloatermToggle<CR>
augroup vimrc_floaterm
  autocmd!
  autocmd User FloatermOpen tnoremap <buffer> <silent> <C-s> <C-\><C-n>:FloatermToggle<CR>
  autocmd QuitPre * FloatermKill!
augroup END

" 参考: https://zenn.dev/kyoh86/articles/b81c401cecc91c
" <C-e>で使えるウィンドウの管理系をターミナルモードにマップする
tnoremap <C-e>n       <cmd>new<cr>
tnoremap <C-e><C-N>   <cmd>new<cr>
tnoremap <C-e>q       <cmd>quit<cr>
tnoremap <C-e><C-Q>   <cmd>quit<cr>
tnoremap <C-e>c       <cmd>close<cr>
tnoremap <C-e>o       <cmd>only<cr>
tnoremap <C-e><C-O>   <cmd>only<cr>
tnoremap <C-e><Down>  <cmd>wincmd j<cr>
tnoremap <C-e><C-J>   <cmd>wincmd j<cr>
tnoremap <C-e>j       <cmd>wincmd j<cr>
tnoremap <C-e><Up>    <cmd>wincmd k<cr>
tnoremap <C-e><C-K>   <cmd>wincmd k<cr>
tnoremap <C-e>k       <cmd>wincmd k<cr>
tnoremap <C-e><Left>  <cmd>wincmd h<cr>
tnoremap <C-e><C-H>   <cmd>wincmd h<cr>
tnoremap <C-e><BS>    <cmd>wincmd h<cr>
tnoremap <C-e>h       <cmd>wincmd h<cr>
tnoremap <C-e><Right> <cmd>wincmd l<cr>
tnoremap <C-e><C-L>   <cmd>wincmd l<cr>
tnoremap <C-e>l       <cmd>wincmd l<cr>
tnoremap <C-e>w       <cmd>wincmd w<cr>
tnoremap <C-e><C-e>   <cmd>wincmd w<cr>
tnoremap <C-e>W       <cmd>wincmd W<cr>
tnoremap <C-e>t       <cmd>wincmd t<cr>
tnoremap <C-e><C-T>   <cmd>wincmd t<cr>
tnoremap <C-e>b       <cmd>wincmd b<cr>
tnoremap <C-e><C-B>   <cmd>wincmd b<cr>
tnoremap <C-e>p       <cmd>wincmd p<cr>
tnoremap <C-e><C-P>   <cmd>wincmd p<cr>
tnoremap <C-e>P       <cmd>wincmd P<cr>
tnoremap <C-e>r       <cmd>wincmd r<cr>
tnoremap <C-e><C-R>   <cmd>wincmd r<cr>
tnoremap <C-e>R       <cmd>wincmd R<cr>
tnoremap <C-e>x       <cmd>wincmd x<cr>
tnoremap <C-e><C-X>   <cmd>wincmd x<cr>
tnoremap <C-e>K       <cmd>wincmd K<cr>
tnoremap <C-e>J       <cmd>wincmd J<cr>
tnoremap <C-e>H       <cmd>wincmd H<cr>
tnoremap <C-e>L       <cmd>wincmd L<cr>
tnoremap <C-e>T       <cmd>wincmd T<cr>
tnoremap <C-e>=       <cmd>wincmd =<cr>
tnoremap <C-e>-       <cmd>wincmd -<cr>
tnoremap <C-e>+       <cmd>wincmd +<cr>
tnoremap <C-e>z       <cmd>pclose<cr>
tnoremap <C-e><C-Z>   <cmd>pclose<cr>
