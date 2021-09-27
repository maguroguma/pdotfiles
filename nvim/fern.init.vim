" nnoremap <silent> <C-f> :<C-u>Fern . -reveal=%<CR>

function! s:init_fern() abort
  nmap <buffer> q :<C-u>quit<CR>
  " nmap <buffer> q :<C-u>Fern . -reveal=%<CR>
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END
