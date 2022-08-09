" カレントバッファの相対ファイルパスをクリップボードレジスタに保存
function! YankCurrentBufferFileRelativePath()
  let l:relative_path = expand("%")
  let l:cur_lnumber = line(".")
  let l:res = l:relative_path . "#L" . l:cur_lnumber
  let @" = l:res
  let @+ = l:res
endfunction
" 絶対パスバージョン
function! YankCurrentBufferFileFullPath()
  let l:full_path = expand("%:p")
  let l:cur_lnumber = line(".")
  let l:res = l:full_path . "#L" . l:cur_lnumber
  redir @" | echo l:res | redir END
  redir @+ | echo l:res | redir END
endfunction
command! YankBufferPath :call YankCurrentBufferFileRelativePath()
command! YankBufferPathFully :call YankCurrentBufferFileFullPath()

" カレントバッファの相対ファイルをカーソル位置に挿入する
inoremap <C-a>bp <C-r>=expand("%")<CR>
cnoremap <C-a>bp <C-r>=expand("%")<CR>
" カレントバッファのフルパス
inoremap <C-a>fp <C-r>=expand("%:p")<CR>
cnoremap <C-a>fp <C-r>=expand("%:p")<CR>

" Vim scriptのヘルプを開く
command! OpenVimScriptHelp :h usr_41

" 今日の日付
inoremap <C-a>day <C-r>=strftime("%Y-%m-%d")<CR>
cnoremap <C-a>day <C-r>=strftime("%Y-%m-%d")<CR>

" markdownのコードスニペット
function! g:ReadTripleBackQuotes(lang_text)
  let l:text = "```" . a:lang_text . "\n```"
  let tmp = @a
  let @a = l:text
  execute 'normal "ap'
  let @a = tmp
endfunction
command! -nargs=1 TripleBackQuotes :call g:ReadTripleBackQuotes(<f-args>)
nnoremap <Leader>` :call g:ReadTripleBackQuotes("")<CR>

" ファイル・バッファのエンコーディング
command! OpenAsSjis :edit ++encoding=sjis<CR>
command! OpenAsUtf8 :e ++enc=utf-8<CR>
command! SaveAsSjis :set fileencoding=cp932<CR>
command! SaveAsUtf8 :se fenc=utf-8<CR>
command! WhatCurEncoding :se enc?
command! WhatCurFEncoding :se fenc?

" タイムスタンプ・日時の相互変換
" JST日時 -> タイムスタンプ: date -j -f "%Y/%m/%d %T" "2019/03/16 11:18:00" "+%s"
" タイムスタンプ -> JST日時: date -j -f "%s" "1552735080" "+%Y/%m/%d %T"

" 行指定範囲のJSONを受け取る
" ※この関数はある程度短いJSONにしか適用できない
function! g:ParseJSONTrial() range
  let l:res = ''
  let l:lnum = a:firstline
  while l:lnum <= a:lastline
    let l:res = l:res . getline(l:lnum)
    let l:lnum = l:lnum + 1
  endwhile

  " echo l:res
  let l:sanitized = substitute(l:res, "\n", "", "g")
  let l:jq_command = printf("echo '%s' | jq .", l:sanitized)
  let l:term_command = printf('terminal %s', l:jq_command)
  call execute('sp')
  call execute(l:term_command)
endfunction

" 行指定ビジュアル範囲の行頭に '- ' を付け加える
command! -range -nargs=0 AddHyphen <line1>,<line2>execute I- 

" バッファフォーカス時にカーソルを強調表示する
" function! EmphasisCursorWrapper() abort
"   EmphasisCursor
" endfunction
" autocmd BufEnter * call EmphasisCursorWrapper()

" https://zenn.dev/uochan/articles/2021-12-08-vim-conventional-commits
function! s:select_type() abort
  let line = substitute(getline('.'), '^#\s*', '', 'g')
  let title = printf('%s: ', split(line, ' ')[0])

  silent! normal! "_dip
  silent! put! =title
  silent! startinsert!
endfunction

nnoremap <buffer> <CR><CR> <Cmd>call <SID>select_type()<CR>

" markdownのリンク生成用コマンド
function! s:GenerateMdLink(text, url)
  let l:presentation_text = '[' . a:text . ']'
  let l:url_text = '(' . a:url . ')'
  let l:output =  l:presentation_text . l:url_text
  " redir @" | echo l:output | redir END
  let @a = l:output
  " normal p
  normal "ap
endfunction
:command! -narg=* -range MdLink :call s:GenerateMdLink(<f-args>)

" confirm qall
nnoremap <leader>qq :<C-u>confirm qall<CR>

" ********

" 範囲指定関数のサンプル
:function Count_words() range
:  let lnum = a:firstline
:  let n = 0
:  while lnum <= a:lastline
:    let n = n + len(split(getline(lnum)))
:    let lnum = lnum + 1
:  endwhile
:  echo "found " . n . " words"
:endfunction

