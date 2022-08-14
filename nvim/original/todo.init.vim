" todoリストを簡単に入力する
inoremap <C-a>todo - [ ]

" 入れ子のリストを折りたたむ
setlocal foldmethod=indent

" todoリストのon/offを切り替える
nnoremap <Leader>o :call ToggleCheckbox()<CR>
vnoremap <Leader>o :call ToggleCheckbox()<CR>

" 選択行のチェックボックスを切り替える
function! ToggleCheckbox()
  let l:line = getline('.')
  if l:line =~ '\-\s\[\s\]'
    let l:result = substitute(l:line, '-\s\[\s\]', '- [x]', '')
    call setline('.', l:result)
  elseif l:line =~ '\-\s\[x\]'
    let l:result = substitute(l:line, '-\s\[x\]', '- [ ]', '')
    call setline('.', l:result)
  end
endfunction

