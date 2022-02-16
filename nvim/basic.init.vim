" https://drumato.hatenablog.com/entry/2019/03/30/215117
" fugitive {{{
" nnoremap <Leader>gl :Glog --oneline<CR>
" nnoremap <Leader>gl :Git log<CR>
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

" lazygit
nnoremap <silent> <Leader>gl :LazyGit<CR>
nnoremap <silent> <Leader>lg :LazyGit<CR>

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
" let g:extra_whitespace_ignored_filetypes = ['explorer']
" augroup HighlightTrailingSpaces
"   autocmd!
"   autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
"   autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
" augroup END

" easymotion
" map <Leader><Leader> <Plug>(easymotion-prefix)
" map <C-j> <Plug>(easymotion-prefix)j
" map <C-k> <Plug>(easymotion-prefix)k
" map <C-h> <Plug>(easymotion-prefix)b
" map <C-l> <Plug>(easymotion-prefix)w
" " https://github.com/KosukeMizuno/dotfiles/blob/2df31b153a5bcc4ed1729eae3f392a3449299f7d/nvim/rc/plugins.toml#L41-L77
" " let g:EasyMotion_do_mapping = 0  " Disable default mappings
" let g:EasyMotion_smartcase = 1
" let g:EasyMotion_startofline = 0
" let g:EasyMotion_use_migemo = 1
" " s連打で戻れるように除く＆押しにくいもの除去＆group prefixは右手に集中させる
" let g:EasyMotion_keys = 'adghlweruiozxcvnmjk'
" " 三文字以上の英単語, 空行以外の行末, CamelCase, _, #
" "" CamelCaseと_#の後は2文字以上あれば候補にする
" let g:EasyMotion_re_wordheads = '\v' .
"     \       '(<\a\a\a)' . '|' .
"     \       '(.$)' . '|' .
"     \       '(\l)\zs(\u\a)' . '|' .
"     \       '(_\zs\a\a)' . '|' .
"     \       '(#\zs\a\a)'
" let g:EasyMotion_re_wordends = '\v' .
"     \       '(\a\a\zs\a>)' . '|' .
"     \       '(^.)' . '|' .
"     \       '(\a\a\a\zs\l\u\a)' . '|' .
"     \       '(\a\a\zs\a_\u\a)' . '|' .
"     \       '(\a\a\zs\a#\u\a)'
" nnoremap <Plug>(easymotion-jumptoheads) <cmd>let g:EasyMotion_re_anywhere = g:EasyMotion_re_wordheads<CR><cmd>call EasyMotion#JumpToAnywhere(0,2)<CR>
" nnoremap <Plug>(easymotion-jumptoends) <cmd>let g:EasyMotion_re_anywhere = g:EasyMotion_re_wordends<CR><cmd>call EasyMotion#JumpToAnywhere(0,2)<CR>
" " 一時的にLSPを停止＆再開
" augroup ToggleEasyMotionGroup
"   autocmd!
"   autocmd User EasyMotionPromptBegin silent! call lsp#disable()
"   autocmd User EasyMotionPromptEnd   silent! call lsp#enable()
" augroup END

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
" let s:ftToIgnore = ['defx', 'denite', '__CtrlSF__']
" autocmd FileType * if index(s:ftToIgnore, &ft) < 0 | execute 'EnableWhitespace' | endif
let g:better_whitespace_filetypes_blacklist = ['diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'fugitive', 'defx', 'ctrlsf']
let g:better_whitespace_ctermcolor = '195'

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

" " nerdcommenter
" filetype on
" " Create default mappings
" let g:NERDCreateDefaultMappings = 1
" " Add spaces after comment delimiters by default
" let g:NERDSpaceDelims = 1
" " Use compact syntax for prettified multi-line comments
" let g:NERDCompactSexyComs = 1
" " Align line-wise comment delimiters flush left instead of following code indentation
" let g:NERDDefaultAlign = 'left'
" " Set a language to use its alternate delimiters by default
" let g:NERDAltDelims_java = 1
" " Add your own custom formats or override the defaults
" let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" " Allow commenting and inverting empty lines (useful when commenting a region)
" let g:NERDCommentEmptyLines = 1
" " Enable trimming of trailing whitespace when uncommenting
" let g:NERDTrimTrailingWhitespace = 1
" " Enable NERDCommenterToggle to check all selected lines is commented or not
" let g:NERDToggleCheckAllLines = 1
" " for nerdcommenter on .vue
" let g:ft = ''
" function! NERDCommenter_before()
"   if &ft == 'vue'
"     let g:ft = 'vue'
"     let stack = synstack(line('.'), col('.'))
"     if len(stack) > 0
"       let syn = synIDattr((stack)[0], 'name')
"       if len(syn) > 0
"         exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
"       endif
"     endif
"   endif
" endfunction
" function! NERDCommenter_after()
"   if g:ft == 'vue'
"     setf vue
"     let g:ft = ''
"   endif
" endfunction

" vim-asterisk
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)

" qfopen.vim
augroup qfopen-bufenter
  function! s:qfopen_keymap() abort
    nmap <buffer> a <Plug>(qfopen-action)
    nmap <buffer> <C-v> <Plug>(qfopen-open-vsplit)
    nmap <buffer> <C-x> <Plug>(qfopen-open-split)
    nmap <buffer> <C-t> <Plug>(qfopen-open-tab)
  endfunction
  au!
  au FileType qf call s:qfopen_keymap()
augroup END

" gitsigns.nvim
lua << EOF
require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter_opts = {
    relative_time = false
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
}
EOF

" vim-brightest
" 下線でハイライトする
" let g:brightest#highlight = {
" \   "group" : "BrightestUnderline"
" \}

" Comment.nvim
lua require('Comment').setup()

" vim-doge
let g:doge_enable_mappings = 0

" glow.nvim
nnoremap <silent> <Leader>mp :<C-u>Glow<CR>
noremap <C-w>z <C-w>\|<C-w>\_

lua << EOF
local cb = require'diffview.config'.diffview_callback

require'diffview'.setup {
  diff_binaries = false,    -- Show diffs for binaries
  enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
  use_icons = true,         -- Requires nvim-web-devicons
  icons = {                 -- Only applies when use_icons is true.
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
  },
  file_panel = {
    position = "left",                  -- One of 'left', 'right', 'top', 'bottom'
    width = 35,                         -- Only applies when position is 'left' or 'right'
    height = 10,                        -- Only applies when position is 'top' or 'bottom'
    listing_style = "tree",             -- One of 'list' or 'tree'
    tree_options = {                    -- Only applies when listing_style is 'tree'
      flatten_dirs = true,              -- Flatten dirs that only contain one single dir
      folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
    },
  },
  file_history_panel = {
    position = "bottom",
    width = 35,
    height = 16,
    log_options = {
      max_count = 256,      -- Limit the number of commits
      follow = false,       -- Follow renames (only for single file)
      all = false,          -- Include all refs under 'refs/' including HEAD
      merges = false,       -- List only merge commits
      no_merges = false,    -- List no merge commits
      reverse = false,      -- List commits in reverse order
    },
  },
  default_args = {    -- Default args prepended to the arg-list for the listed commands
    DiffviewOpen = {},
    DiffviewFileHistory = {},
  },
  hooks = {},         -- See ':h diffview-config-hooks'
  key_bindings = {
    disable_defaults = false,                   -- Disable the default key bindings
    -- The `view` bindings are active in the diff buffers, only when the current
    -- tabpage is a Diffview.
    view = {
      ["<tab>"]      = cb("select_next_entry"),  -- Open the diff for the next file
      ["<s-tab>"]    = cb("select_prev_entry"),  -- Open the diff for the previous file
      ["gf"]         = cb("goto_file"),          -- Open the file in a new split in previous tabpage
      ["<C-w><C-f>"] = cb("goto_file_split"),    -- Open the file in a new split
      ["<C-w>gf"]    = cb("goto_file_tab"),      -- Open the file in a new tabpage
      ["<leader>e"]  = cb("focus_files"),        -- Bring focus to the files panel
      ["<leader>b"]  = cb("toggle_files"),       -- Toggle the files panel.
    },
    file_panel = {
      ["j"]             = cb("next_entry"),           -- Bring the cursor to the next file entry
      ["<down>"]        = cb("next_entry"),
      ["k"]             = cb("prev_entry"),           -- Bring the cursor to the previous file entry.
      ["<up>"]          = cb("prev_entry"),
      ["<cr>"]          = cb("select_entry"),         -- Open the diff for the selected entry.
      ["o"]             = cb("select_entry"),
      ["<2-LeftMouse>"] = cb("select_entry"),
      ["-"]             = cb("toggle_stage_entry"),   -- Stage / unstage the selected entry.
      ["S"]             = cb("stage_all"),            -- Stage all entries.
      ["U"]             = cb("unstage_all"),          -- Unstage all entries.
      ["X"]             = cb("restore_entry"),        -- Restore entry to the state on the left side.
      ["R"]             = cb("refresh_files"),        -- Update stats and entries in the file list.
      ["<tab>"]         = cb("select_next_entry"),
      ["<s-tab>"]       = cb("select_prev_entry"),
      ["gf"]            = cb("goto_file"),
      ["<C-w><C-f>"]    = cb("goto_file_split"),
      ["<C-w>gf"]       = cb("goto_file_tab"),
      ["i"]             = cb("listing_style"),        -- Toggle between 'list' and 'tree' views
      ["f"]             = cb("toggle_flatten_dirs"),  -- Flatten empty subdirectories in tree listing style.
      ["<leader>e"]     = cb("focus_files"),
      ["<leader>b"]     = cb("toggle_files"),
    },
    file_history_panel = {
      ["g!"]            = cb("options"),            -- Open the option panel
      ["<C-A-d>"]       = cb("open_in_diffview"),   -- Open the entry under the cursor in a diffview
      ["y"]             = cb("copy_hash"),          -- Copy the commit hash of the entry under the cursor
      ["zR"]            = cb("open_all_folds"),
      ["zM"]            = cb("close_all_folds"),
      ["j"]             = cb("next_entry"),
      ["<down>"]        = cb("next_entry"),
      ["k"]             = cb("prev_entry"),
      ["<up>"]          = cb("prev_entry"),
      ["<cr>"]          = cb("select_entry"),
      ["o"]             = cb("select_entry"),
      ["<2-LeftMouse>"] = cb("select_entry"),
      ["<tab>"]         = cb("select_next_entry"),
      ["<s-tab>"]       = cb("select_prev_entry"),
      ["gf"]            = cb("goto_file"),
      ["<C-w><C-f>"]    = cb("goto_file_split"),
      ["<C-w>gf"]       = cb("goto_file_tab"),
      ["<leader>e"]     = cb("focus_files"),
      ["<leader>b"]     = cb("toggle_files"),
    },
    option_panel = {
      ["<tab>"] = cb("select"),
      ["q"]     = cb("close"),
    },
  },
}
EOF
