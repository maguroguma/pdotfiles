"
" https://qiita.com/arks22/items/9688ec7f4cb43444e9d9
"

autocmd FileType defx call s:defx_my_settings()

function! s:defx_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
   \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> c
  \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
  \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')
  " nnoremap <silent><buffer><expr> l
  " \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> l
  \ defx#do_action('open')
  nnoremap <silent><buffer><expr> t
  \ defx#do_action('open','tabnew')
  nnoremap <silent><buffer><expr> E
  \ defx#do_action('drop', 'vsplit')
  nnoremap <silent><buffer><expr> P
  \ defx#do_action('drop', 'pedit')
  nnoremap <silent><buffer><expr> o
  \ defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> O         defx#do_action('open_tree_recursive')
  " nnoremap <silent><buffer><expr> K
  " \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
  \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M
  \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C
  \ defx#do_action('toggle_columns',
  \                'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
  \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d
  \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
  \ defx#do_action('execute_command')
  " nnoremap <silent><buffer><expr> x
  " \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> x
  \ defx#do_action('close_tree')
  nnoremap <silent><buffer><expr> yy
  \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
  \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ;
  \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h
  \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
  \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
  \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
  \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ? 'G' : 'k'
  " nnoremap <silent><buffer><expr> <C-l>
  " \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> R
  \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
  \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
  \ defx#do_action('change_vim_cwd')
endfunction

" open時に開いておく（これをしないとtrailing-white-spaceプラグインと干渉する）
" autocmd VimEnter * execute 'Defx'
" ファイルを指定せずにvimを実行したときはdefxを開いておく、そうでない場合は開かない
" 参考: https://wonderwall.hatenablog.com/entry/2016/04/06/213105
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | Defx | endif
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" 起動
" nnoremap <silent> <Leader>n :<C-u>Defx<CR>
nnoremap <silent> <C-f> :<C-u>Defx<CR>
" nnoremap <silent> <C-g> :<C-u>Defx <C-r>=expand('%:h')<CR><CR>

" 左ペイン常駐
" call defx#custom#option('_', {
"   \ 'winwidth': 40,
"   \ 'split': 'vertical',
"   \ 'direction': 'topleft',
"   \ 'show_ignored_files': 1,
"   \ 'buffer_name': 'explorer',
"   \ 'toggle': 1,
"   \ 'resume': 1,
"   \ 'columns': 'indent:git:icons:filename:mark',
"   \ })
" ウィンドウ
call defx#custom#option('_', {
  \ 'show_ignored_files': 1,
  \ 'buffer_name': 'explorer',
  \ 'toggle': 1,
  \ 'resume': 1,
  \ 'columns': 'indent:git:icons:filename:mark',
  \ })

call defx#custom#column('git', 'indicators', {
  \ 'Modified'  : '✹',
  \ 'Staged'    : '✚',
  \ 'Untracked' : '✭',
  \ 'Renamed'   : '➜',
  \ 'Unmerged'  : '═',
  \ 'Ignored'   : '☒',
  \ 'Deleted'   : '✖',
  \ 'Unknown'   : '?'
  \ })

" 外部のファイル操作を自動で反映する
autocmd BufWritePost * call defx#redraw()
autocmd BufEnter * call defx#redraw()

