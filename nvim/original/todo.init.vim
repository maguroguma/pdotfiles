" https://qiita.com/naoty_k/items/56eddc9b76fe630f9be7

" todoリストを簡単に入力する
" abbreviate tl - [ ]
inoremap <C-a>todo - [ ]

" 入れ子のリストを折りたたむ
setlocal foldmethod=indent

" todoリストのon/offを切り替える
" nnoremap <buffer> <Leader>x :call ToggleCheckbox()<CR>
" vnoremap <buffer> <Leader>x :call ToggleCheckbox()<CR>
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

