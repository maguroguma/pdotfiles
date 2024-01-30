let s:treesitter_scripts =<< END
lua << EOF
-- PLUGSETTING: nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
  parser_install_dir = vim.fn.expand("$XDG_DATA_HOME/nvim/site/pack/jetpack/nvim-treesitter"),
}
EOF
END
let g:jetpack_treesitter_scripts = join(s:treesitter_scripts, "\n")

let s:fzf_scripts =<< END
"""
" commands
"""
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(
    \   <q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}),
    \   <bang>0)

command! -bang -nargs=? -complete=dir Buffers
    \ call fzf#vim#buffers(
    \   <q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}),
    \   <bang>0)

" deletes buffers by fzf
" ref: https://github.com/junegunn/fzf.vim/pull/733#issuecomment-559720813
function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:list_buffers_customized()
  redir => list
  silent ls
  redir END

  let l:res = []
  let l:raw_lines = split(list, "\n")
  for l:raw_line in raw_lines
    let l:elems = split(l:raw_line)
    let l:custom_line = l:elems[0] . "\t" . substitute(l:elems[2], '"', "", "g")
    call add(l:res, l:custom_line)
  endfor
 return l:res
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers_customized(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept --prompt "delete(close) buffers> "'
\ }))

"""
" custom git show with gina.vim
"""
" source
function! s:list_commits() abort
  let l:res = system('git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --color=always')
  return split(l:res, "\n")
endfunction
" sink
function! s:select_commits(commit_hash) abort
  let l:list = split(a:commit_hash, ' ')
  let l:execute_command = 'Gina show ' . l:list[1] . ':%'
  execute l:execute_command
endfunction
command! GinaShow call fzf#run(fzf#wrap({
  \ 'source': s:list_commits(),
  \ 'sink': funcref('s:select_commits'),
  \ 'options': '--ansi --prompt "git show of the buffer> "',
\ }))

"""
" custom insert command from history
"""
" source
function! s:list_command_history() abort
  let l:res = system("cat $HISTFILE | cut -b 16- | head -n 5000")
  return reverse(split(l:res, "\n"))
endfunction
" sink
function! s:insert_target(shell_command) abort
  call setline(line("."), a:shell_command)
endfunction
command! HCommand call fzf#run(fzf#wrap({
  \ 'source': s:list_command_history(),
  \ 'sink': funcref('s:insert_target'),
  \ 'options': '--ansi --prompt "replace current line> "',
\ }))

"""
" layouts, styles
"""

" popup window
let g:fzf_layout = { 'window': { 'width': 0.5, 'height': 0.4, 'yoffset': 0.5 } }

" Empty value to disable preview window altogether
let g:fzf_preview_window = []

nnoremap <silent> , :Marks<CR>
nnoremap <silent> <Space>h :Helptags<CR>
nnoremap <silent> <Space>gf :GitFiles?<CR>
nnoremap <silent> <Space>q :History:<CR>
nnoremap <silent> <Space>bd :BD<CR>
END
let g:jetpack_fzf_scripts = join(s:fzf_scripts, "\n")

let s:memolist_scripts =<< END
let g:memolist_path = expand("$GOPATH/src/github.com/maguroguma/memolist")
let g:memolist_memo_suffix = "md"
let g:memolist_memo_date = "%Y-%m-%d %H:%M"
let g:memolist_prompt_tags = 1
let g:memolist_prompt_categories = 1
let g:memolist_fzf = 1
END
let g:jetpack_memolist_scripts = join(s:memolist_scripts, "\n")

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SECTION: depeding on environment
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:cmp_scripts =<< END
lua << EOF
-- Set up nvim-cmp.
local cmp = require'cmp'

local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

cmp.setup {
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      -- Source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[LaTeX]",
      })[entry.source.name]
      return vim_item
    end
  },
}

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   },
--   view = {
--     entries = {name = 'custom', selection_order = 'near_cursor' }
--   },
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  view = {
    entries = {name = 'custom', selection_order = 'near_cursor' }
  },
})
EOF
END
let g:jetpack_cmp_scripts = join(s:cmp_scripts, "\n")

let s:nvim_tree_scripts =<< END
lua << EOF
local HEIGHT_RATIO = 0.5  -- You can change this
local WIDTH_RATIO = 0.4   -- You can change this too

require('nvim-tree').setup({
  view = {
    float = {
      enable = true,
      open_win_config = function()
        local screen_w = vim.opt.columns:get()
        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
        local window_w = screen_w * WIDTH_RATIO
        local window_h = screen_h * HEIGHT_RATIO
        local window_w_int = math.floor(window_w)
        local window_h_int = math.floor(window_h)
        local center_x = (screen_w - window_w) / 2
        local center_y = ((vim.opt.lines:get() - window_h) / 2)
                         - vim.opt.cmdheight:get()
        return {
          border = {
            "+", "=", "+", "|", "+", "=", "+", "|",
          },
          relative = 'editor',
          row = center_y,
          col = center_x,
          width = window_w_int,
          height = window_h_int,
        }
        end,
    },
    width = function()
      return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
    end,
    mappings = {
      list = {
        { key = "o", action = "edit_no_picker" },
        { key = "l", action = "edit_no_picker", action_cb = edit_or_open },
        -- { key = "L", action = "vsplit_preview", action_cb = vsplit_preview },
        { key = "h", action = "close_node" },
        -- { key = "H", action = "collapse_all", action_cb = collapse_all }
        { key = "=", action = "cd" },
        { key = "J", action = "" },
        { key = "K", action = "" },
      },
    },
  },
  renderer = {
    full_name = true,
    group_empty = true,
    special_files = {},
    symlink_destination = true,
    indent_markers = {
      enable = true,
    },
    icons = {
      git_placement = "signcolumn",
      show = {
        file = true,
        folder = true,
        folder_arrow = false,
        git = true,
      },
    },
  },
  git = {
    ignore = false,
  },
})
EOF
END
let g:jetpack_nvim_tree_scripts = join(s:nvim_tree_scripts, "\n")

let s:undotree_scripts =<< END
let g:undotree_WindowLayout = 2         " undotreeは左側/diffは下にウィンドウ幅で表示
let g:undotree_ShortIndicators = 1      " 時間単位は短く表示
let g:undotree_SplitWidth = 40          " undotreeのウィンドウ幅
let g:undotree_SetFocusWhenToggle = 1   " undotreeを開いたらフォーカスする
"let g:undotree_DiffAutoOpen = 0         " diffウィンドウは起動時無効
let g:undotree_DiffpanelHeight = 8      " diffウィンドウの行数
"let g:undotree_HighlightChangedText = 0 " 変更箇所のハイライト無効
END
let g:jetpack_undotree_scripts = join(s:undotree_scripts, "\n")

let s:floaterm_scripts =<< END
" 参考: https://github.com/yutkat/dotfiles/blob/28e8df61c39727fa85d3f289343eb60feffd29d8/.config/nvim/rc/pluginconfig/vim-floaterm.vim
let g:floaterm_height = 0.95
let g:floaterm_width = 0.95
augroup vimrc_floaterm
  autocmd!
  autocmd User FloatermOpen tnoremap <buffer> <silent> <C-s> <C-\><C-n>:FloatermToggle<CR>
  autocmd QuitPre * FloatermKill!
augroup END
END
let g:jetpack_floaterm_scripts = join(s:floaterm_scripts, "\n")

let s:vim_go_scripts =<< END
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
" LSPに任せる機能をOFFにする
let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0

" autocmd FileType go nmap <Space>b  <Plug>(go-build)
autocmd FileType go nmap <Space>r  <Plug>(go-run)
autocmd FileType go nmap <Space>t  <Plug>(go-test)
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction
autocmd FileType go nmap <Space>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <Space>c <Plug>(go-coverage-toggle)

" ハイライト
" :help go-settings
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

" let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_autosave = 0
" オートで実行するものは選定できる
" let g:go_metalinter_autosave_enabled = ['vet', 'golint']
END
let g:jetpack_vim_go_scripts = join(s:vim_go_scripts, "\n")

let s:dial_scripts =<< END
vmap  <C-a>  <Plug>(dial-increment)
vmap  <C-x>  <Plug>(dial-decrement)
vmap g<C-a> g<Plug>(dial-increment)
vmap g<C-x> g<Plug>(dial-decrement)
END
let g:jetpack_dial_scripts = join(s:dial_scripts, "\n")

let s:fern_scripts =<< END
" nmap <C-f> :<C-u>Fern . -reveal=%<CR>
let g:fern#renderer = "nerdfont"
let g:fern#renderer#nerdfont#indent_markers = 1

function! s:init_fern() abort
  " Use 'select' instead of 'edit' for default 'open' action
  " nmap <buffer> <Plug>(fern-action-open) <Plug>(fern-action-open:select)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END
END
let g:jetpack_fern_scripts = join(s:fern_scripts, "\n")

let s:pounce_scripts =<< END
highlight PounceMatch      cterm=underline,bold ctermfg=49 ctermbg=236
highlight PounceMatch      gui=underline,bold guifg=#555555 guibg=#FFAF60
highlight PounceGap        cterm=underline,bold ctermfg=214 ctermbg=236
highlight PounceGap        gui=underline,bold guifg=#555555 guibg=#E27878
highlight PounceAccept     cterm=underline,bold ctermfg=184 ctermbg=236
highlight PounceAccept     gui=underline,bold guifg=#FFAF60 guibg=#555555
highlight PounceAcceptBest cterm=underline,bold ctermfg=196 ctermbg=236
highlight PounceAcceptBest gui=underline,bold guifg=#EE2513 guibg=#555555

lua << EOF
require'pounce'.setup{
  accept_keys = "HJKLYUIOPNMQWERTASDFGZXCVB",
  accept_best_key = "<enter>",
  multi_window = true,
  debug = false,
}
EOF
END
let g:jetpack_pounce_scripts = join(s:pounce_scripts, "\n")

let s:todo_comments_scripts =<< END
lua << EOF
-- PLUGSETTING: folke/todo-comments.nvim
-- FIXME:
-- TODO:
-- BUG:
-- PERF:
-- HACK:
-- WARNING:
  require("todo-comments").setup {
  signs = true, -- show icons in the signs column
  sign_priority = 8, -- sign priority
  -- keywords recognized as todo comments
  keywords = {
    FIX = {
      icon = " ", -- icon used for the sign, and in search results
      color = "error", -- can be a hex color, or a named color (see below)
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
  },
  merge_keywords = true, -- when true, custom keywords will be merged with the defaults
  -- highlighting of the line containing the todo comment
  -- * before: highlights before the keyword (typically comment characters)
  -- * keyword: highlights of the keyword
  -- * after: highlights after the keyword (todo text)
  highlight = {
    before = "", -- "fg" or "bg" or empty
    keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
    after = "fg", -- "fg" or "bg" or empty
    pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
    comments_only = true, -- uses treesitter to match keywords in comments only
    max_line_len = 400, -- ignore lines longer than this
    exclude = {}, -- list of file types to exclude highlighting
  },
  -- list of named colors where we try to extract the guifg from the
  -- list of hilight groups or use the hex color if hl not found as a fallback
  colors = {
    error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
    warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
    info = { "DiagnosticInfo", "#2563EB" },
    hint = { "DiagnosticHint", "#10B981" },
    default = { "Identifier", "#7C3AED" },
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    -- regex that will be used to match keywords.
    -- don't replace the (KEYWORDS) placeholder
    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
  },
}
EOF
END
let g:jetpack_todo_comments_scripts = join(s:todo_comments_scripts, "\n")

let s:aerial_scripts =<< END
lua << EOF
-- PLUGSETTING: stevearc/aerial.nvim
require('aerial').setup({
  -- Priority list of preferred backends for aerial.
  -- This can be a filetype map (see :help aerial-filetype-map)
  backends = { "treesitter", "lsp", "markdown", "man" },

  layout = {
    win_opts = {
      winblend = 10,
    },
    -- default_direction = 'float',
    placement = 'edge',
  },

  -- Options for opening aerial in a floating win
  float = {
    -- Controls border appearance. Passed to nvim_open_win
    border = "rounded",

    -- Determines location of floating window
    --   cursor - Opens float on top of the cursor
    --   editor - Opens float centered in the editor
    --   win    - Opens float centered in the window
    relative = "win",

    -- These control the height of the floating window.
    -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_height and max_height can be a list of mixed types.
    -- min_height = {8, 0.1} means "the greater of 8 rows or 10% of total"
    max_height = 0.9,
    height = nil,
    min_height = { 8, 0.1 },

    override = function(conf, source_winid)
      -- This is the config that will be passed to nvim_open_win.
      -- Change values here to customize the layout
      conf.anchor = 'NE'
      conf.col = vim.fn.winwidth(source_winid)
      conf.row = 0
      return conf
    end,
  },

  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
  end
})
-- You probably also want to set a keymap to toggle aerial
-- vim.keymap.set('n', '<Space>a', '<cmd>AerialToggle<CR>')
EOF
END
let g:jetpack_aerial_scripts = join(s:aerial_scripts, "\n")

let s:better_escape_scripts =<< END
lua << EOF
-- PLUGSETTING: max397574/better-escape.nvim
-- lua, default settings
require("better_escape").setup {
    mapping = {"jj", "jk", "kj"}, -- a table with mappings to use
    timeout = 200, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
    clear_empty_lines = false, -- clear line after escaping if there is only whitespace
    keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
    -- example(recommended)
    -- keys = function()
    --   return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
    -- end,
}
EOF
END
let g:jetpack_better_escape_scripts = join(s:better_escape_scripts, "\n")

let s:committia_scripts =<< END
" https://zenn.dev/uochan/articles/2021-12-08-vim-conventional-commits
nnoremap ZZ <cmd>call g:SelectType()<CR>
function! g:SelectType() abort
  if &filetype ==? "gitcommit" || &filetype ==? "gina-commit"
    let line = substitute(getline('.'), '^#\s*', '', 'g') " 最初の '# ' を除く
    let arr = split(line, ' ')
    let title = printf('%s: %s ', arr[0], arr[1])

    silent! normal! "_dip
    silent! put! =title
    silent! startinsert!
  else
    echoerr 'This is not gitcommit buffer!'
    return
  endif
endfunction
END
let g:jetpack_committia_scripts = join(s:committia_scripts, "\n")

let s:coc_scripts =<< END
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <C-n>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" NOTE: leximaの設定で変更する
" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gh <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
" K -> gh
nnoremap <silent> gh :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <Space>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <Space>f  <Plug>(coc-format-selected)
nmap <Space>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<Space>aap` for current paragraph
xmap <Space>a  <Plug>(coc-codeaction-selected)
nmap <Space>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <Space>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
" nmap <Space>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <Space>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
" xmap if <Plug>(coc-funcobj-i)
" omap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap af <Plug>(coc-funcobj-a)
" xmap ic <Plug>(coc-classobj-i)
" omap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
" if has('nvim-0.4.0') || has('patch-8.2.0750')
"   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" original(from vim-jp)
" https://vim-jp.slack.com/archives/CQ88WB7B3/p1659323660504669
" NOTE: なぜかguiの方は色設定がうまくできない
highlight CocMenuSel cterm=bold ctermbg=18
highlight CocMenuSel gui=bold
highlight CocSearch cterm=bold ctermfg=44
highlight CocSearch gui=bold

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" " Mappings for CoCList
" " Show all diagnostics.
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions.
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " Show commands.
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document.
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols.
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list.
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"""
" coc extensions
"""
let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-prettier',
      \ 'coc-pyright',
      \ 'coc-tsserver',
      \ 'coc-ultisnips',
      \ 'coc-vetur',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-yaml',
      \ 'coc-sh',
      \ 'coc-word',
      \ 'coc-syntax',
      \ 'coc-docker',
      \ 'coc-tailwindcss',
      \ 'coc-deno',
      \ 'coc-fzf-preview',
      \ 'coc-vimlsp',
      \ ]

" fzf-preview
let g:fzf_preview_floating_window_rate = 0.9

"""
" node path
"""
" let g:coc_node_path = '/path/to/node'
END
let g:jetpack_coc_scripts = join(s:coc_scripts, "\n")

let s:hlslens_scripts =<< END
lua << EOF
require('hlslens').setup({
    nearest_only = true
})

local kopts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('n', 'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>zz]],
    kopts)
vim.api.nvim_set_keymap('n', 'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>zz]],
    kopts)

-- vim-asterisk integration
vim.api.nvim_set_keymap('n', '*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
vim.api.nvim_set_keymap('n', '#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
vim.api.nvim_set_keymap('n', 'g*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
vim.api.nvim_set_keymap('n', 'g#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})
vim.api.nvim_set_keymap('x', '*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
vim.api.nvim_set_keymap('x', '#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
vim.api.nvim_set_keymap('x', 'g*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
vim.api.nvim_set_keymap('x', 'g#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})
EOF
END
let g:jetpack_hlslens_scripts = join(s:hlslens_scripts, "\n")

let s:lexima_scripts =<< END
" yuki-yanoさんのスクリプトを参考に
" https://github.com/yuki-yano/dotfiles/blob/1c865f70c5ca3c2b4b59181c30bdb69ac6a0870a/.vimrc
" '\%#' はカーソル位置を表す
function! s:setup_lexima_insert() abort
  let s:rules = []

  "" markdown
  let s:rules += [
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\%#',                        'input': '<C-w><CR>',                         },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><CR>',                    },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s*-\s\w.*\%#',                 'input': '<CR>-<Space>',                      },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\[\%#\]',                    'input': '<End><C-w><C-w><C-w><CR>',          },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\[\%#\]',                'input': '<End><C-w><C-w><C-w><C-w><CR>',     },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><CR>',               },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><CR>',          },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<CR>-<Space>[]<Space><Left><Left>', },
  \ ]
  "" markdown(original)
  let s:rules += [
  \ { 'filetype': 'markdown', 'char': '<Space>', 'at': '\[\%#', 'input': '<Space>'},
  \ ]

  for s:rule in s:rules
    call lexima#add_rule(s:rule)
  endfor
endfunction

function! SetupLexima() abort
  call s:setup_lexima_insert()
endfunction

call SetupLexima()

" cocの補完をEnterで決定する（leximaの設定を上書きする）
inoremap <silent><expr> <C-j> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
END
let g:jetpack_lexima_scripts = join(s:lexima_scripts, "\n")

let s:emmet_scripts =<< END
let g:user_emmet_leader_key='<C-e>'
END
let g:jetpack_emmet_scripts = join(s:emmet_scripts, "\n")

let s:jsdoc_scripts =<< END
let g:jsdoc_formatter = 'tsdoc'
END
let g:jetpack_jsdoc_scripts = join(s:jsdoc_scripts, "\n")

let s:choosewin_scripts =<< END
" オーバーレイ機能を有効にしたい場合
let g:choosewin_overlay_enable          = 1
" オーバーレイ・フォントをマルチバイト文字を含むバッファでも綺麗に表示する。
let g:choosewin_overlay_clear_multibyte = 1
let g:choosewin_label = 'HJKLYUIONM'
END
let g:jetpack_choosewin_scripts = join(s:choosewin_scripts, "\n")

let s:bookmarks_scripts =<< END
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1
let g:bookmark_no_default_key_mappings = 1
END
let g:jetpack_bookmarks_scripts = join(s:bookmarks_scripts, "\n")

let s:better_whitespace_scripts =<< END
let g:better_whitespace_filetypes_blacklist = ['diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'fugitive', 'defx']
let g:better_whitespace_ctermcolor = '12'
highlight ExtraWhitespace ctermbg=159
highlight ExtraWhitespace guibg=#caedfc
END
let g:jetpack_better_whitespace_scripts = join(s:better_whitespace_scripts, "\n")

let s:highlightedyank_scripts =<< END
let g:highlightedyank_highlight_duration = 500
END
let g:jetpack_highlightedyank_scripts = join(s:highlightedyank_scripts, "\n")

let s:ripgrep_scripts =<< END
command! -nargs=+ -complete=file Ripgrep :call ripgrep#search(<q-args>)
END
let g:jetpack_ripgrep_scripts = join(s:ripgrep_scripts, "\n")

let s:neotree_scripts =<< END
lua << EOF
-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- If you want icons for diagnostic errors, you'll need to define them somewhere:
vim.fn.sign_define("DiagnosticSignError",
  {text = " ", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn",
  {text = " ", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInfo",
  {text = " ", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint",
  {text = "", texthl = "DiagnosticSignHint"})
-- NOTE: this is changed from v1.x, which used the old style of highlight groups
-- in the form "LspDiagnosticsSignWarning"

require("neo-tree").setup({
  close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  sort_case_insensitive = false, -- used when sorting files and directories in the tree
  sort_function = nil , -- use a custom function for sorting files and directories in the tree 
  -- sort_function = function (a,b)
  --       if a.type == b.type then
  --           return a.path > b.path
  --       else
  --           return a.type > b.type
  --       end
  --   end , -- this sorts files and directories descendantly
  default_component_configs = {
    container = {
      enable_character_fade = true
    },
    indent = {
      indent_size = 2,
      padding = 1, -- extra padding on left hand side
      -- indent guides
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
      -- expander config, needed for nesting files
      with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "ﰊ",
      -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
      -- then these will never be used.
      default = "*",
      highlight = "NeoTreeFileIcon"
    },
    modified = {
      symbol = "[+]",
      highlight = "NeoTreeModified",
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
      highlight = "NeoTreeFileName",
    },
    git_status = {
      symbols = {
        -- Change type
        added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
        modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
        deleted   = "✖",-- this can only be used in the git_status source
        renamed   = "",-- this can only be used in the git_status source
        -- Status type
        untracked = "",
        ignored   = "",
        unstaged  = "",
        staged    = "",
        conflict  = "",
      }
    },
  },
  window = {
    position = "current",
    width = 40,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      ["<space>"] = { 
          "toggle_node", 
          nowait = true, -- disable `nowait` if you have existing combos starting with this char that you want to use 
      },
      ["<2-LeftMouse>"] = "open",
      ["l"] = "open",
      ["<esc>"] = "revert_preview",
      ["P"] = { "toggle_preview", config = { use_float = true } },
      -- ["l"] = "focus_preview",
      ["S"] = "open_split",
      ["s"] = "open_vsplit",
      -- ["S"] = "split_with_window_picker",
      -- ["s"] = "vsplit_with_window_picker",
      ["t"] = "open_tabnew",
      -- ["<cr>"] = "open_drop",
      -- ["t"] = "open_tab_drop",
      ["w"] = "open_with_window_picker",
      --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
      ["h"] = "close_node",
      ["z"] = "noop",
      --["Z"] = "expand_all_nodes",
      ["a"] = { 
        "add",
        -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
        -- some commands may take optional config options, see `:h neo-tree-mappings` for details
        config = {
          show_path = "none" -- "none", "relative", "absolute"
        }
      },
      ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
      -- ["c"] = {
      --  "copy",
      --  config = {
      --    show_path = "none" -- "none", "relative", "absolute"
      --  }
      --}
      ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
      ["q"] = "close_window",
      ["R"] = "refresh",
      ["?"] = "show_help",
      ["<"] = "prev_source",
      [">"] = "next_source",
    }
  },
  nesting_rules = {},
  filesystem = {
    filtered_items = {
      visible = false, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = true, -- only works on Windows for hidden files/directories
      hide_by_name = {
        --"node_modules"
      },
      hide_by_pattern = { -- uses glob style patterns
        --"*.meta",
        --"*/src/*/tsconfig.json",
      },
      always_show = { -- remains visible even if other settings would normally hide it
        --".gitignored",
      },
      never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
        --".DS_Store",
        --"thumbs.db"
      },
      never_show_by_pattern = { -- uses glob style patterns
        --".null-ls_*",
      },
    },
    follow_current_file = false, -- This will find and focus the file in the active buffer every
                                 -- time the current file is changed while the tree is open.
    group_empty_dirs = false, -- when true, empty folders will be grouped together
    hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
                                            -- in whatever position is specified in window.position
                          -- "open_current",  -- netrw disabled, opening a directory opens within the
                                            -- window like netrw would, regardless of window.position
                          -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
    use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
                                    -- instead of relying on nvim autocmd events.
    window = {
      mappings = {
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["H"] = "toggle_hidden",
        ["/"] = "fuzzy_finder",
        ["D"] = "fuzzy_finder_directory",
        ["f"] = "filter_on_submit",
        ["<c-x>"] = "clear_filter",
        ["[g"] = "prev_git_modified",
        ["]g"] = "next_git_modified",
      }
    }
  },
  buffers = {
    follow_current_file = true, -- This will find and focus the file in the active buffer every
                                 -- time the current file is changed while the tree is open.
    group_empty_dirs = true, -- when true, empty folders will be grouped together
    show_unloaded = true,
    window = {
      mappings = {
        ["bd"] = "buffer_delete",
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
      }
    },
  },
  git_status = {
    window = {
      position = "float",
      mappings = {
        ["A"]  = "git_add_all",
        ["gu"] = "git_unstage_file",
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
      }
    }
  }
})
EOF
END
let g:jetpack_neotree_scripts = join(s:neotree_scripts, "\n")

let s:gina_scripts =<< END
" 現在のバッファのファイルをcheckoutする
function! s:gitCheckoutThis()
  let l:confirm_msg = 'You checkout this buffer file, OK?'
  let l:is_ok = confirm(l:confirm_msg, "y yes\nn no")
  if l:is_ok != 1
    return
  endif
  :Gina checkout %
endfunction
command! GinaCheckoutThis :call s:gitCheckoutThis()
command! -range GinaBrowseThese <line1>,<line2>Gina browse --exact HEAD:%
let g:gina#command#blame#formatter#format = "%su%=on %au %ti %ma%in"
END
let g:jetpack_gina_scripts = join(s:gina_scripts, "\n")
