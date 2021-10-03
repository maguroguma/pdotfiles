" https://drumato.hatenablog.com/entry/2019/03/30/215117
" fugitive {{{
" nnoremap <Leader>gl :Glog --oneline<CR>
nnoremap <Leader>gl :Git log<CR>
" nnoremap <Leader>gs :Git<CR>
nnoremap <Leader>gs :Gina status<CR>
" nnoremap <Leader>gd :Gdiffsplit<CR>
nnoremap <Leader>gd :Git diff %<CR>
nnoremap <Leader>gb :Git blame<CR>
" nnoremap <Leader>ga :Gwrite<CR>
" nnoremap <Leader>gc :Gcommit<CR>
" command! Gdiff :Git diff
command! Gdiff :Gina diff
command! GdiffCached :Gina diff --cached
command! Gblame :Git blame
" }}}

"" vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" emmet-vim
" emmet-vimの展開キー
let g:user_emmet_leader_key='<C-t>'

" rainbow
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

" vim-highlightedyank
let g:highlightedyank_highlight_duration = 1000

" trailing white space
" autocmd BufWritePre * :FixWhitespace
let g:extra_whitespace_ignored_filetypes = ['explorer']
" augroup HighlightTrailingSpaces
"   autocmd!
"   autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
"   autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
" augroup END

" easymotion
map <Leader><Leader> <Plug>(easymotion-prefix)

" open-browser.vim
" vmap <Leader>b <Plug>(openbrowser-smart-search)
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" vim-diminactive
" let g:diminactive_use_syntax = 1

" vim-better-whitespace
" defx, denite以外で有効にする
" autocmd FileType * if &filetype != "defx" | execute 'EnableWhitespace' | endif
let s:ftToIgnore = ['defx', 'denite']
autocmd FileType * if index(s:ftToIgnore, &ft) < 0 | execute 'EnableWhitespace' | endif

" Goyo
let g:goyo_width = 120

" surround vim
" https://rcmdnk.com/blog/2014/05/03/computer-vim-octopress/
xmap <Leader>* S*gvS*

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ヘルプの言語を日本語優先にする
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set helplang=ja

" 自動的にディレクトリを作成する: https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
augroup vimrc-auto-mkdir  " {{{
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)  " {{{
    if !isdirectory(a:dir) && (a:force ||
    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction  " }}}
augroup END  " }}}

" すべてのファイルでTODO:などをハイライトする
" http://baqamore.hatenablog.com/entry/2016/11/15/220358
augroup HilightsForce
  autocmd!
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('Todo', '\(TODO\|NOTE\|INFO\|XXX\|TEMP\):')
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight Todo guibg=Red guifg=White
augroup END

