" markdown-preview.vim
" nmap <silent> <Leader>mp <Plug>MarkdownPreview
" nmap <silent> <Leader>smp <Plug>StopMarkdownPreview

" mdpdfコマンドによるmarkdownからのPDFファイル生成コマンド
function! Mdpdf() abort
  if expand('%:e') != 'md'
    return
  endif
  let l:command = 'mdpdf ' . expand('%:p')
  call system(l:command)
  call system('open ' . expand('%:r') . '.pdf')
endfunction

command! Mdpdf call Mdpdf()

" vim-maketable
" MakeTable - CSV -> Table
" MakeTable! - CSV -> Table(including header row)
" MakeTable! \t - TSV -> Table(?)
" UnmakeTable - Table -> CSV

" vim-markdown-toc
" :GenTocXXX
