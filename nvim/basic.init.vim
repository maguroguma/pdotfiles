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
let g:user_emmet_leader_key='<C-e>'

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
map <C-j> <Plug>(easymotion-prefix)j
map <C-k> <Plug>(easymotion-prefix)k
map <C-h> <Plug>(easymotion-prefix)b
map <C-l> <Plug>(easymotion-prefix)w
" https://github.com/KosukeMizuno/dotfiles/blob/2df31b153a5bcc4ed1729eae3f392a3449299f7d/nvim/rc/plugins.toml#L41-L77
" let g:EasyMotion_do_mapping = 0  " Disable default mappings
let g:EasyMotion_smartcase = 1
let g:EasyMotion_startofline = 0
let g:EasyMotion_use_migemo = 1
" s連打で戻れるように除く＆押しにくいもの除去＆group prefixは右手に集中させる
let g:EasyMotion_keys = 'adghlweruiozxcvnmjk'
" 三文字以上の英単語, 空行以外の行末, CamelCase, _, #
"" CamelCaseと_#の後は2文字以上あれば候補にする
let g:EasyMotion_re_wordheads = '\v' .
    \       '(<\a\a\a)' . '|' .
    \       '(.$)' . '|' .
    \       '(\l)\zs(\u\a)' . '|' .
    \       '(_\zs\a\a)' . '|' .
    \       '(#\zs\a\a)'
let g:EasyMotion_re_wordends = '\v' .
    \       '(\a\a\zs\a>)' . '|' .
    \       '(^.)' . '|' .
    \       '(\a\a\a\zs\l\u\a)' . '|' .
    \       '(\a\a\zs\a_\u\a)' . '|' .
    \       '(\a\a\zs\a#\u\a)'
nnoremap <Plug>(easymotion-jumptoheads) <cmd>let g:EasyMotion_re_anywhere = g:EasyMotion_re_wordheads<CR><cmd>call EasyMotion#JumpToAnywhere(0,2)<CR>
nnoremap <Plug>(easymotion-jumptoends) <cmd>let g:EasyMotion_re_anywhere = g:EasyMotion_re_wordends<CR><cmd>call EasyMotion#JumpToAnywhere(0,2)<CR>
" 一時的にLSPを停止＆再開
augroup ToggleEasyMotionGroup
  autocmd!
  autocmd User EasyMotionPromptBegin silent! call lsp#disable()
  autocmd User EasyMotionPromptEnd   silent! call lsp#enable()
augroup END

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

" 折りたたみを自動で保存し、自動で読み込む
" https://vim-jp.org/vim-users-jp/2009/10/08/Hack-84.html
" Save fold settings.
" autocmd BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
" autocmd BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent loadview | endif
" " Don't save options.
" set viewoptions-=options

" nerdcommenter
filetype on
" Create default mappings
let g:NERDCreateDefaultMappings = 1
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1
" for nerdcommenter on .vue
let g:ft = ''
function! NERDCommenter_before()
  if &ft == 'vue'
    let g:ft = 'vue'
    let stack = synstack(line('.'), col('.'))
    if len(stack) > 0
      let syn = synIDattr((stack)[0], 'name')
      if len(syn) > 0
        exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
      endif
    endif
  endif
endfunction
function! NERDCommenter_after()
  if g:ft == 'vue'
    setf vue
    let g:ft = ''
  endif
endfunction
