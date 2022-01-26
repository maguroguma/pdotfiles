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
" <C-w>で使えるウィンドウの管理系をターミナルモードにマップする
tnoremap <C-W>n       <cmd>new<cr>
tnoremap <C-W><C-N>   <cmd>new<cr>
tnoremap <C-W>q       <cmd>quit<cr>
tnoremap <C-W><C-Q>   <cmd>quit<cr>
tnoremap <C-W>c       <cmd>close<cr>
tnoremap <C-W>o       <cmd>only<cr>
tnoremap <C-W><C-O>   <cmd>only<cr>
tnoremap <C-W><Down>  <cmd>wincmd j<cr>
tnoremap <C-W><C-J>   <cmd>wincmd j<cr>
tnoremap <C-W>j       <cmd>wincmd j<cr>
tnoremap <C-W><Up>    <cmd>wincmd k<cr>
tnoremap <C-W><C-K>   <cmd>wincmd k<cr>
tnoremap <C-W>k       <cmd>wincmd k<cr>
tnoremap <C-W><Left>  <cmd>wincmd h<cr>
tnoremap <C-W><C-H>   <cmd>wincmd h<cr>
tnoremap <C-W><BS>    <cmd>wincmd h<cr>
tnoremap <C-W>h       <cmd>wincmd h<cr>
tnoremap <C-W><Right> <cmd>wincmd l<cr>
tnoremap <C-W><C-L>   <cmd>wincmd l<cr>
tnoremap <C-W>l       <cmd>wincmd l<cr>
" tnoremap <C-W>w       <cmd>wincmd w<cr>
" tnoremap <C-W><C-W>   <cmd>wincmd w<cr>
" tnoremap <C-W>W       <cmd>wincmd W<cr>
tnoremap <C-W>t       <cmd>wincmd t<cr>
tnoremap <C-W><C-T>   <cmd>wincmd t<cr>
tnoremap <C-W>b       <cmd>wincmd b<cr>
tnoremap <C-W><C-B>   <cmd>wincmd b<cr>
tnoremap <C-W>p       <cmd>wincmd p<cr>
tnoremap <C-W><C-P>   <cmd>wincmd p<cr>
tnoremap <C-W>P       <cmd>wincmd P<cr>
tnoremap <C-W>r       <cmd>wincmd r<cr>
tnoremap <C-W><C-R>   <cmd>wincmd r<cr>
tnoremap <C-W>R       <cmd>wincmd R<cr>
tnoremap <C-W>x       <cmd>wincmd x<cr>
tnoremap <C-W><C-X>   <cmd>wincmd x<cr>
tnoremap <C-W>K       <cmd>wincmd K<cr>
tnoremap <C-W>J       <cmd>wincmd J<cr>
tnoremap <C-W>H       <cmd>wincmd H<cr>
tnoremap <C-W>L       <cmd>wincmd L<cr>
tnoremap <C-W>T       <cmd>wincmd T<cr>
tnoremap <C-W>=       <cmd>wincmd =<cr>
tnoremap <C-W>-       <cmd>wincmd -<cr>
tnoremap <C-W>+       <cmd>wincmd +<cr>
tnoremap <C-W>z       <cmd>pclose<cr>
tnoremap <C-W><C-Z>   <cmd>pclose<cr>
" wordの削除は残す
tnoremap <C-W><C-W> <C-w>
