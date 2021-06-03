let g:sonictemplate_vim_template_dir = [
      \ '~/go/src/github.com/maguroguma/go-competitive/template'
      \]

" quoted from: https://gist.github.com/AmaiSaeta/8631399
" function! g:Ls(all)
function! g:Ls()
" Return the STRUCTURED all buffer informations that is similar :ls.
" @param[in]	all	Include "unlisted" buffer informations.
" @return
" 	Buffer informations. It's a List that contains Dictionary of a buffer
" 	informatin. Its Dictionary is composed these members:
" 		bufnr:      Buffer number.
" 		unlisted:   If 1, this buffer is "unlisted", otherwise 0.
"		focus:      "%" means in current window. "#" means alternate buffer.
"		active:     "a" means active buffer. "h" means hidden buffer.
"		modifiable: If 1, this buffer with 'modifiable' off, otherwise 0.
"		readonly:   If 1, a readonly buffer.
"		modified:   If 1, a modified buffer.
"		readerror:  If 1, a buffer with read errors.
"		bufname:    Buffer name. it's like bufname(), but has few different.
"		line:       Cursor position.

	" Get :ls result
	redir => cRes0
		" execute 'silent ls' . (a:all ? '!' : '')
    " execute 'silent ls hF'
    execute 'silent filter /term:\/\// ls'
	redir END
	let cRes = split(cRes0, "\n")
	unlet cRes0

	" Parse
	let sRes = []
	for i in cRes
		" Parse a line of :ls.
		let items = map(
		\	matchlist(i, '\v^\s*(\d+)(.)(.)(.)(.)(.)\s+"([^"]+)".{-}(\d+).*$'),
		\	'v:val == " " ? "" : v:val')
		call add(sRes, {
		\	'bufnr'     : items[1],
		\	'unlisted'  : len(items[2]),
		\	'focus'     : items[3],
		\	'active'    : items[4],
		\	'modifiable': items[5] != '-',
		\	'readonly'  : items[5] == '=',
		\	'modified'  : items[6] == '+',
		\	'readerror' : items[6] == 'x',
		\	'bufname'   : items[7],
		\	'line'      : items[8]
		\ })
	endfor

	return sRes
endfunction

function! g:DeleteTermBuffers()
  let l:bufDict = g:Ls()

  for l:buf in l:bufDict
    let l:execCom = "bd! " . l:buf["bufnr"]
    let l:msg = "Delete buffer No." . l:buf["bufnr"] . ": " . l:buf["bufname"]
    echo l:msg
    execute l:execCom
  endfor

  return
endfunction

command! -nargs=0 OjDeleteHFTermBuffers :call DeleteTermBuffers()

if executable('oj')
  let g:oj_helper_submit_confirms = {
        \'codeforces': 'こどふぉだけどオーバーフロー大丈夫？',
        \'yukicoder': '',
        \}
  let g:oj_helper_lang_commands = {
        \'bash': 'bash',
        \}
  let g:oj_helper_lang_extensions = {
        \'bash': 'sh',
        \}
  let g:oj_helper_executable_binary = 'main.exe'
  let g:oj_helper_search_url_s_line = 0
  let g:oj_helper_search_url_t_line = 5
  let g:oj_helper_testcase_dir_name = 'testcases'

  command! -nargs=0 OjTest :OjLangCommandTest go
  " command! -nargs=0 TestSamples :OjLangCommandTest go
  " command! -nargs=0 DownloadSamples :OjDownloadSamples
  " command! -nargs=0 Submit :OjSubmitCode
endif
