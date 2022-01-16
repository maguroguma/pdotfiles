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
