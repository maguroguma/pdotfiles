-- PLUGSETTING: lualine
-- ref: https://www.reddit.com/r/neovim/comments/xy0tu1/cmdheight0_recording_macros_message/
function _G.show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "🎬RECORDING MACRO @" .. recording_register .. "🎬"
  end
end

local lualine = require('lualine')
lualine.setup {
  options = {
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    theme = 'everforest',

    disabled_filetypes = {
      statusline = { "Avante", "AvanteInput", "AvanteSelectedFiles" },
      winbar = { "Avante", "AvanteInput", "AvanteSelectedFiles" },
    },

    always_show_tabline = false, -- タブが1つだけのときはタブラインを隠す
  },
  sections = {
    lualine_a = {
      {
        "macro-recording",
        fmt = show_macro_recording,
      },
      'mode',
    },
    lualine_b = { 'location' },
    lualine_c = {
      {
        'filename',
        path = 1,
        shorting_target = 40,
        newfile_status = true,   -- Display new file status (new file means no write after created)
        symbols = {
          modified = '[+]',      -- Text to show when the file is modified.
          readonly = '[-RO]',    -- Text to show when the file is non-modifiable or readonly.
          unnamed = '[No Name]', -- Text to show for unnamed buffers.
          newfile = '[New]',     -- Text to show for new created file before first writting
        },
      },
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'branch' },
    lualine_z = {}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        path = 1,
        shorting_target = 40,
      },
    },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  -- buffer line は表示せず、タブページのみをタブラインに表示する
  tabline = {
    lualine_a = {
      {
        'tabs',
        mode = 2, -- 0: タブ番号のみ / 1: タブ名のみ / 2: 番号+名前
        path = 0, -- 0: ファイル名のみ / 1: 相対パス / 2: 絶対パス
        -- タブラインの最大幅（リサイズに追従させるため関数で指定する）
        max_length = function()
          return vim.o.columns
        end,
        use_mode_colors = false,
        symbols = {
          modified = ' [+]', -- Text to show when the tab contains a modified buffer.
        },
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
}
vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    lualine.refresh({
      place = { "statusline" },
    })
  end,
})
vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    -- This is going to seem really weird!
    -- Instead of just calling refresh we need to wait a moment because of the nature of
    -- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
    -- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
    -- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
    -- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
    local timer = vim.loop.new_timer()
    timer:start(
      50,
      0,
      vim.schedule_wrap(function()
        lualine.refresh({
          place = { "statusline" },
        })
      end)
    )
  end,
})

-- PLUGSETTING: lewis6991/gitsigns.nvim
require('gitsigns').setup {
  -- 極太: █
  signs                        = {
    add          = { text = '▌' },
    change       = { text = '▌' },
    delete       = { text = '━' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signs_staged                 = {
    add          = { text = '▌' },
    change       = { text = '▌' },
    delete       = { text = '━' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl                        = true,  -- Toggle with `:Gitsigns toggle_numhl`
  linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir                 = {
    follow_files = true
  },
  auto_attach                  = true,
  attach_to_untracked          = false,
  current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts      = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  sign_priority                = 6,
  update_debounce              = 100,
  status_formatter             = nil,   -- Use default
  max_file_length              = 40000, -- Disable if file is longer than this (in lines)
  preview_config               = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },

  on_attach                    = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    -- map('n', ']c', function()
    --   if vim.wo.diff then
    --     vim.cmd.normal({']c', bang = true})
    --   else
    --     gitsigns.nav_hunk('next')
    --   end
    -- end)
    --
    -- map('n', '[c', function()
    --   if vim.wo.diff then
    --     vim.cmd.normal({'[c', bang = true})
    --   else
    --     gitsigns.nav_hunk('prev')
    --   end
    -- end)

    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk)
    map('n', '<leader>hr', gitsigns.reset_hunk)
    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('v', '<leader>hr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)
    map('n', '<leader>hS', gitsigns.stage_buffer)
    map('n', '<leader>hR', gitsigns.reset_buffer)

    -- map('n', '<leader>hp', gitsigns.preview_hunk)
    -- map('n', '<leader>hi', gitsigns.preview_hunk_inline)
    --
    -- map('n', '<leader>hb', function()
    --   gitsigns.blame_line({ full = true })
    -- end)
    --
    -- map('n', '<leader>hd', gitsigns.diffthis)
    --
    -- map('n', '<leader>hD', function()
    --   gitsigns.diffthis('~')
    -- end)
    --
    -- map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
    -- map('n', '<leader>hq', gitsigns.setqflist)
    --
    -- -- Toggles
    -- map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
    -- map('n', '<leader>td', gitsigns.toggle_deleted)
    -- map('n', '<leader>tw', gitsigns.toggle_word_diff)
    --
    -- -- Text object
    -- map({'o', 'x'}, 'ih', gitsigns.select_hunk)
  end
}

vim.keymap.set('n', 'gn', function()
  require('gitsigns').nav_hunk('next', { target = 'all' })
end)
vim.keymap.set('n', 'gN', function()
  require('gitsigns').nav_hunk('prev', { target = 'all' })
end)

vim.keymap.set("n", "<Space>gb", "<cmd>Gitsigns blame<CR>")
vim.keymap.set("n", "gp", "<cmd>Gitsigns preview_hunk_inline<CR>")

-- PLUGSETTING: lewis6991/satellite.nvim
-- ファイル内の相対位置と残りの長さを、右端のスクロールバーで把握するために使う。
-- 注意: marks ハンドラは ma〜mZ にマッピングを足す。既存のマッピングは奪わないので、
-- vim-bookmarks の mm / ml（init.vim 側で先に定義）はそのまま使える。
local ok_satellite, satellite = pcall(require, 'satellite')
if ok_satellite then
  satellite.setup {
    width = 2,
    winblend = 50,
    handlers = {
      cursor = { enable = true },
      search = { enable = true },
      diagnostic = { enable = true },
      gitsigns = { enable = true },
      marks = { enable = true, show_builtins = false },
      quickfix = { enable = true },
    },
  }
else
  vim.notify('satellite.nvim が読み込めません: ' .. tostring(satellite), vim.log.levels.WARN)
end

-- PLUGSETTING: folke/todo-comments.nvim
-- FIXME:
-- TODO:
-- BUG:
-- PERF:
-- HACK:
-- WARNING:
require("todo-comments").setup {
  signs = true,      -- show icons in the signs column
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
    before = "",                     -- "fg" or "bg" or empty
    keyword = "wide",                -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
    after = "fg",                    -- "fg" or "bg" or empty
    pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
    comments_only = true,            -- uses treesitter to match keywords in comments only
    max_line_len = 400,              -- ignore lines longer than this
    exclude = {},                    -- list of file types to exclude highlighting
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

-- PLUGSETTING: nvim-hlslens
require('hlslens').setup({
  nearest_only = true
})

local kopts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', 'n',
  [[<Cmd>execute('keepjumps normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>zz]],
  kopts)
vim.api.nvim_set_keymap('n', 'N',
  [[<Cmd>execute('keepjumps normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>zz]],
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

-- PLUGSETTING: nvim-treesitter/nvim-treesitter
require('nvim-treesitter').setup {
  install_dir = vim.fn.expand("$XDG_DATA_HOME/nvim/site/pack/jetpack/nvim-treesitter"),
}

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- PLUGSETTING: nvim-neo-tree/neo-tree.nvim
-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- If you want icons for diagnostic errors, you'll need to define them somewhere:
vim.fn.sign_define("DiagnosticSignError",
  { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",
  { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",
  { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",
  { text = "", texthl = "DiagnosticSignHint" })
-- NOTE: this is changed from v1.x, which used the old style of highlight groups
-- in the form "LspDiagnosticsSignWarning"

require("neo-tree").setup({
  close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  sort_case_insensitive = false, -- used when sorting files and directories in the tree
  sort_function = nil,           -- use a custom function for sorting files and directories in the tree
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
        deleted   = "✖", -- this can only be used in the git_status source
        renamed   = "", -- this can only be used in the git_status source
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
      -- ["s"] = "open_vsplit",
      ["s"] = "noop",
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
    follow_current_file = {
      enabled = false,                      -- This will find and focus the file in the active buffer every time
      --               -- the current file is changed while the tree is open.
      leave_dirs_open = false,              -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
    group_empty_dirs = false,               -- when true, empty folders will be grouped together
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
    follow_current_file = {
      enabled = true,          -- This will find and focus the file in the active buffer every time
      --              -- the current file is changed while the tree is open.
      leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
    group_empty_dirs = true,   -- when true, empty folders will be grouped together
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

-- PLUGSETTING: nvim-cmp
local cmp = require 'cmp'

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
  -- skkeleton（日本語入力）が有効な間は補完を無効化する
  enabled = function()
    if vim.fn['skkeleton#is_enabled']() then
      return false
    end
    return true
  end,

  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    -- cmp が表示中にアクティブな候補があれば確定し、なければ fallback（lexima の <CR>）を呼ぶ
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_active_entry() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
      else
        fallback()
      end
    end, { 'i' }),
  }),

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  }),

  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[Lua]",
        path = "[Path]",
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
    entries = { name = 'custom', selection_order = 'near_cursor' }
  },
})

-- PLUGSETTING: pounce
require 'pounce'.setup {
  accept_keys = "HJKLYUIOPNMQWERTASDFGZXCVB",
  accept_best_key = "<enter>",
  multi_window = true,
  debug = false,
}

-- PLUGSETTING: mvllow/modes.nvim
require('modes').setup({
  colors = {
    copy = "#f5c359",
    delete = "#c75c6a",
    insert = "#78ccc5",
    -- visual = "#9745be",
    visual = "#f5c359",
  },

  -- Set opacity for cursorline and number background
  line_opacity = 0.2,

  -- Enable cursor highlights
  set_cursor = true,

  -- Enable cursorline initially, and disable cursorline for inactive windows
  -- or ignored filetypes
  set_cursorline = true,

  -- Enable line number highlights to match cursorline
  set_number = true,

  -- Disable modes highlights in specified filetypes
  -- Please PR commonly ignored filetypes
  ignore = { 'NvimTree', 'TelescopePrompt' }
})

-- PLUGSETTING: stevearc/aerial.nvim
require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,

  layout = {
    -- 最大幅を大きく設定（例：80列または画面幅の50%）
    max_width = { 80, 0.8 },
    min_width = 20,
    -- コンテンツに応じてリサイズを有効化
    resize_to_content = true,

    default_direction = "left"
  },

  -- Options for opening aerial in a floating win
  float = {
    relative = "win",
    max_height = 0.9,
  },
})
-- You probably also want to set a keymap to toggle aerial
-- vim.keymap.set("n", "F", "<cmd>AerialToggle! float<CR>")
vim.keymap.set("n", "<Space>ae", "<cmd>AerialToggle!<CR>")

-- PLUGSETTING: shellRaining/hlchunk.nvim
require("hlchunk").setup({
  chunk = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  line_num = {
    enable = true,
  },
  blank = {
    enable = true,
  },
})

-- PLUGSETTING: kazhala/close-buffers.nvim
require('close_buffers').setup({
  filetype_ignore = {},                            -- Filetype to ignore when running deletions
  file_glob_ignore = {},                           -- File name glob pattern to ignore when running deletions (e.g. '*.md')
  file_regex_ignore = {},                          -- File name regex pattern to ignore when running deletions (e.g. '.*[.]md')
  preserve_window_layout = { 'this', 'nameless' }, -- Types of deletion that should preserve the window layout
  next_buffer_cmd = nil,                           -- Custom function to retrieve the next buffer when preserving window layout
})

vim.keymap.set('n', '<Space>d', "<cmd>BDelete hidden<cr>", { noremap = true, silent = false })
vim.keymap.set('n', '<Space>D', "<cmd>BWipeout all<cr>", { noremap = true, silent = false })

-- PLUGSETTING: Wansmer/treesj
require('treesj').setup({
  use_default_keymaps = false,
})

-- PLUGSETTING: folke/noice.nvim
require('noice').setup({
  cmdline = {
    view = "cmdline_popup",
    -- view = "cmdline",
    opts = {
      position = { row = '40%', col = '50%' },
    },
  },
  -- メッセージを noice のフロートに回すことで、hit-enter プロンプト
  -- （Press ENTER or type command to continue）が出なくなる。
  -- 端末幅が狭いと g<C-g> 程度の短いメッセージでもロックしていたため有効化した。
  -- 幅が狭いとフロートの末尾が欠けることがあるが、:messages を実行すれば
  -- noice 専用の split が開き、全文を折り返し表示でゆっくり読める（q で閉じる）。
  messages = {
    enabled = true,
  },
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
})

-- PLUGSETTING: delphinus/skkeleton_indicator.nvim
-- require("skkeleton_indicator").setup {
--   -- octo バッファではインジケータを出さない。
--   -- octo.nvim は PR バッファ生成時に undo 履歴を消すため、undolevels=-1 の状態で
--   -- `:normal a <BS>` を実行する（octo/utils.lua の clear_history）。
--   -- このとき InsertEnter が発火し、skkeleton_indicator がフロートウィンドウを
--   -- 新規作成すると octo バッファの undo チェーンが壊れて E439 が発生する。
--   -- その後そのバッファを削除すると Neovim 本体が SIGSEGV で落ちるため除外する。
--   ignoreFt = { "octo" },
-- }

-- PLUGSETTING: stevearc/quicker.nvim
require("quicker").setup()

-- PLUGSETTING: nvim-treesitter/nvim-treesitter-context
-- vim.api.nvim_set_hl(0, "TreesitterContext", { bold = true, bg = "#393b47" })
-- vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, bold = true })
-- vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bold = true })
-- vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = true, bold = true })

-- PLUGSETTING: jiaoshijie/undotree
require('undotree').setup()
vim.keymap.set('n', '<leader>u', require('undotree').toggle, { noremap = true, silent = true })

-- PLUGSETTING: windwp/nvim-ts-autotag
require('nvim-ts-autotag').setup({
  opts = {
    -- Defaults
    enable_close = true,          -- Auto close tags
    enable_rename = true,         -- Auto rename pairs of tags
    enable_close_on_slash = false -- Auto close on trailing </
  },
  -- Also override individual filetype configs, these take priority.
  -- Empty by default, useful if one of the "opts" global settings
  -- doesn't work well in a specific filetype
  -- per_filetype = {
  --   ["html"] = {
  --     enable_close = false
  --   }
  -- }
})

-- PLUGSETTING: MeanderingProgrammer/render-markdown.nvim
require('render-markdown').setup({
  file_types = { "Avante", "markdown", "copilot-chat" },

  heading = {
    width = "full",
    -- left_pad = 0,
    -- right_pad = 4,
    icons = {},
    -- backgrounds = {
    --     'RenderMarkdownH1Bg',
    --     'RenderMarkdownH1Bg',
    --     'RenderMarkdownH1Bg',
    --     'RenderMarkdownH1Bg',
    --     'RenderMarkdownH1Bg',
    --     'RenderMarkdownH1Bg',
    -- },
    foregrounds = {
      'RenderMarkdownH1',
      'RenderMarkdownH1',
      'RenderMarkdownH1',
      'RenderMarkdownH1',
      'RenderMarkdownH1',
      'RenderMarkdownH1',
    },
  },

  code = {
    width = "block",
    right_pad = 4,
  },

  render_modes = true,

  win_options = {
    conceallevel = {
      default = 0,  -- 通常時の非表示レベルを0（すべて表示）にする
      rendered = 0, -- レンダリング時も0にする
    }
  }
})
vim.api.nvim_set_hl(0, 'RenderMarkdownH1Bg', { bg = '#b5b37b' }) -- 濃い緑
vim.api.nvim_set_hl(0, 'RenderMarkdownH2Bg', { bg = '#c5c39b' }) -- 少し薄い緑
vim.api.nvim_set_hl(0, 'RenderMarkdownH3Bg', { bg = '#d5d39b' }) -- さらに薄い緑
vim.api.nvim_set_hl(0, 'RenderMarkdownH4Bg', { bg = '#e5e3bb' }) -- 薄い緑
vim.api.nvim_set_hl(0, 'RenderMarkdownH5Bg', { bg = '#f5f3db' }) -- とても薄い緑
vim.api.nvim_set_hl(0, 'RenderMarkdownH6Bg', { bg = '#ffffff' }) -- 白

-- PLUGSETTING: ibhagwan/fzf-lua
local actions = require("fzf-lua").actions
require('fzf-lua').setup({
  winopts = {
    height  = 0.6, -- window height
    width   = 0.8, -- window width
    row     = 0.5, -- window row position (0=top, 1=bottom)
    col     = 0.5, -- window col position (0=left, 1=right)

    preview = {
      default  = false,
      vertical = "down:50%", -- up|down:size
      layout   = "vertical", -- horizontal|vertical|flex
    },
  },
  git = {
    status = {
      prompt  = 'GitStatus❯ ',
      actions = {
        ["right"]  = false,
        ["left"]   = false,
        ["ctrl-l"] = { fn = actions.git_unstage, reload = true },
        ["ctrl-h"] = { fn = actions.git_stage, reload = true },
        ["ctrl-x"] = { fn = actions.git_reset, reload = true },
      },
    },
  },
  buffers = {
    prompt = 'Buffers❯ ',
  },
})
-- light theme だとまぶしかったので暗くした MediumSpringGreen -> CadetBlue4
vim.api.nvim_set_hl(0, "FzfLuaHeaderBind", { fg = "CadetBlue4" })
vim.api.nvim_set_hl(0, "FzfLuaPathLineNr", { fg = "CadetBlue4" })
vim.api.nvim_set_hl(0, "FzfLuaTabMarker", { fg = "CadetBlue4" })

-- 共通オプション
local opts_with_no_ignore = {
  no_ignore = true,                           -- git ignore を無視
  file_ignore_patterns = { "^node_modules" }, -- node_modules のみ除外
  hidden = true,                              -- 隠しファイルも含める
}
-- 1. nmap: ファイルをバッファで開く
vim.keymap.set("n", "<C-]>", function()
  require("fzf-lua").files(opts_with_no_ignore)
end, { silent = true, desc = "FzfLua files (no ignore, exclude node_modules)" })
-- 2. imap: 相対パスを挿入
vim.keymap.set("i", "<C-a>f", function()
  require("fzf-lua").complete_file(vim.tbl_extend("force", opts_with_no_ignore, {
    cmd = "rg --color=never --files --no-ignore -g '!.git' --hidden", -- ← 明示指定
    actions = {
      ["default"] = require("fzf-lua").actions.complete,
    },
    winopts = {
      preview = { hidden = false },
    },
  }))
end, { silent = true, desc = "Insert file path (no ignore, exclude node_modules)" })

-- insert mode で <C-a>gb に git branch completion を設定
vim.keymap.set("i", "<C-a>gb", function()
  require("fzf-lua").git_branches({
    complete = function(selected, opts, line, col)
      -- ブランチ名を行の先頭から抽出（'*' と余白を除去）
      local branch = selected[1]:match("^%s*%*?%s*([^%s]+)")
      -- カーソル位置にブランチ名を挿入
      local newline = line:sub(1, col) .. branch .. line:sub(col + 1)
      return newline, col + #branch
    end
  })
end, { silent = true, desc = "Complete git branch at cursor" })

-- insert mode で <C-a>gr に ghq リポジトリのフルパス挿入を設定
vim.keymap.set("i", "<C-a>gq", function()
  require("fzf-lua").fzf_exec("ghq list --full-path", {
    prompt = "ghq list> ",
    complete = true,
  })
end, { silent = true, desc = "Insert ghq repository full path at cursor" })

-- insert mode で <C-a>gc に git commit completion を設定
vim.keymap.set("i", "<C-a>gc", function()
  require("fzf-lua").git_commits({
    -- 複数選択を有効化（デフォルトの --no-multi を上書き）
    fzf_opts = { ["--multi"] = true },
    complete = function(selected, opts, line, col)
      local hashes = {}
      for _, item in ipairs(selected) do
        -- コミットハッシュを抽出（先頭の単語）
        local hash = item:match("^%s*([^%s]+)")
        if hash then
          table.insert(hashes, hash)
        end
      end
      -- スペース区切りで結合
      local commit_str = table.concat(hashes, " ")
      local newline = line:sub(1, col) .. commit_str .. line:sub(col + 1)
      return newline, col + #commit_str
    end
  })
end, { silent = true, desc = "Complete git commit hashes at cursor" })

-- ai-notes（AI エージェントの記録を置くリポジトリ）を fzf-lua で開く
-- <Space>k は knowledge の k。置き場所は scripts/ai-notes-path.sh と同じく AI_NOTES_DIR で差し替えられる。
--   <Space>kk -> ai-notes 全体をファイル名で探す（新しい順）。<C-k> にも同じ動作を割り当てている
--   <Space>kr -> 今いるリポジトリの raw/<名前空間>/ だけに絞って探す
--   <Space>kg -> ai-notes の中身を live grep する
--   <Space>kw -> wiki の索引を開く

--- ai-notes のルートディレクトリを返す。
--- AI_NOTES_DIR が設定されていればそれを、無ければ $GOPATH/src/github.com/maguroguma/ai-notes を使う。
---@return string
local function ai_notes_root()
  if vim.env.AI_NOTES_DIR and vim.env.AI_NOTES_DIR ~= "" then
    return vim.env.AI_NOTES_DIR
  end
  local gopath = (vim.env.GOPATH and vim.env.GOPATH ~= "") and vim.env.GOPATH or vim.fn.expand("~/go")
  return gopath .. "/src/github.com/maguroguma/ai-notes"
end

--- ai-notes のルートが存在すれば返し、無ければ通知して nil を返す。
---@return string|nil
local function ensure_ai_notes_root()
  local root = ai_notes_root()
  if vim.fn.isdirectory(root) == 0 then
    vim.notify("ai-notes が見つかりません: " .. root, vim.log.levels.WARN)
    return nil
  end
  return root
end

--- 指定ディレクトリ配下のファイルを、新しい順（パスの降順）に fuzzy find する。
--- raw/ は YYYY/MM/DD で掘っているため、パスの降順がそのまま新しい順になる。
---@param cwd string 検索の起点ディレクトリ
---@param prompt string fzf のプロンプト
local function ai_notes_files(cwd, prompt)
  require("fzf-lua").files({
    cwd = cwd,
    prompt = prompt,
    cmd = "rg --files --color=never --hidden -g '!.git' --sortr path",
    winopts = { preview = { hidden = false } },
  })
end

--- 今いるリポジトリに対応する ai-notes の raw/<名前空間> ディレクトリを返す。
--- 名前空間の決め方を二重に実装しないよう、scripts/ai-notes-path.sh に任せる。
---@return string|nil dir 求められなかった場合は nil
---@return string|nil err 失敗した理由
local function ai_notes_repo_dir()
  local script = vim.fn.expand("~/dotfiles/scripts/ai-notes-path.sh")
  if vim.fn.filereadable(script) == 0 then
    return nil, "スクリプトが見つかりません: " .. script
  end

  local ok, result = pcall(function()
    return vim.system({ "bash", script }, { cwd = vim.fn.getcwd(), text = true }):wait()
  end)
  if not ok then
    return nil, "スクリプトを実行できませんでした: " .. tostring(result)
  end
  if result.code ~= 0 then
    return nil, "スクリプトが失敗しました: " .. vim.trim(result.stderr or "")
  end

  -- 出力は raw/<名前空間>/YYYY/MM/DD なので、日付の 3 階層を取り除く
  return vim.fn.fnamemodify(vim.trim(result.stdout or ""), ":h:h:h"), nil
end

--- ai-notes 全体をファイル名で探す。<Space>kk と <C-k> の両方から呼ぶ。
local function ai_notes_find_all()
  local root = ensure_ai_notes_root()
  if not root then return end
  ai_notes_files(root, "ai-notes❯ ")
end

vim.keymap.set("n", "<Space>kk", ai_notes_find_all, { silent = true, desc = "ai-notes: 全体をファイル名で探す" })
vim.keymap.set("n", "<C-k>", ai_notes_find_all, { silent = true, desc = "ai-notes: 全体をファイル名で探す" })

vim.keymap.set("n", "<Space>kr", function()
  if not ensure_ai_notes_root() then return end
  local dir, err = ai_notes_repo_dir()
  if not dir then
    vim.notify("ai-notes: " .. err, vim.log.levels.ERROR)
    return
  end
  if vim.fn.isdirectory(dir) == 0 then
    vim.notify("ai-notes: このリポジトリの記録はまだありません: " .. dir, vim.log.levels.INFO)
    return
  end
  ai_notes_files(dir, "ai-notes(repo)❯ ")
end, { silent = true, desc = "ai-notes: 今いるリポジトリの記録を探す" })

vim.keymap.set("n", "<Space>kg", function()
  local root = ensure_ai_notes_root()
  if not root then return end
  require("fzf-lua").live_grep({ cwd = root, prompt = "ai-notes(grep)❯ " })
end, { silent = true, desc = "ai-notes: 中身を live grep する" })

vim.keymap.set("n", "<Space>kw", function()
  local root = ensure_ai_notes_root()
  if not root then return end
  vim.cmd.edit(vim.fn.fnameescape(root .. "/wiki/index.md"))
end, { silent = true, desc = "ai-notes: wiki の索引を開く" })

-- PLUGSETTING: uga-rosa/ccc.nvim
require("ccc").setup()

-- PLUGSETTING: chrisgrieser/nvim-origami
-- default settings
require("origami").setup {
  useLspFoldsWithTreesitterFallback = {
    enabled = true,
    foldmethodIfNeitherIsAvailable = "indent", ---@type string|fun(bufnr: number): string
  },
  pauseFoldsOnSearch = true,
  foldtext = {
    enabled = true,
    padding = { width = 3 },
    lineCount = {
      template = "%d lines", -- `%d` is replaced with the number of folded lines
      hlgroup = "Comment",
    },
    diagnosticsCount = true, -- uses hlgroups and icons from `vim.diagnostic.config().signs`
    gitsignsCount = true,    -- requires `gitsigns.nvim`
    disableOnFt = { "snacks_picker_input" }, ---@type string[]
  },
  autoFold = {
    enabled = true,
    kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
  },
  foldKeymaps = {
    setup = true,                   -- modifies `h`, `l`, `^`, and `$`
    closeOnlyOnFirstColumn = false, -- `h` and `^` only close in the 1st column
    scrollLeftOnCaret = false,      -- `^` should scroll left (basically mapped to `0^`)
  },
}

-- PLUGSETTING: A7Lavinraj/fyler.nvim
local fyler = require("fyler")
fyler.setup({
  views = {
    finder = {
      mappings = {
        ["q"] = "CloseView",
        ["<CR>"] = "Select",
        zM = "CollapseAll",
        zc = "CollapseNode",

        --[[yank path variants]]
        yp = function(finder)
          local path = finder:cursor_node_entry().path
          vim.fn.setreg(vim.v.register, path)
          vim.notify("絶対パスをヤンクしました: " .. path, vim.log.levels.INFO)
        end,
        yr = function(finder)
          local path = vim.fn.fnamemodify(finder:cursor_node_entry().path, ":.")
          vim.fn.setreg(vim.v.register, path)
          vim.notify("相対パスをヤンクしました: " .. path, vim.log.levels.INFO)
        end,

        -- [[Toggle node]]
        Z = function(finder)
          local entry = finder:cursor_node_entry()
          if vim.fn.isdirectory(entry.path) == 1 then
            finder:exec_action "n_select"
          else
            finder:exec_action "n_collapse_node"
          end
        end,

        --[[disabled defaults]]
        ["<C-t>"] = false,
        ["|"] = false,
        ["-"] = false,
        ["^"] = false,
        ["="] = false,
        ["."] = false,
        ["#"] = false,
        ["<BS>"] = false,
      }
    }
  }
})
vim.keymap.set("n", "<leader>f", fyler.open, { desc = "Open fyler View" })

-- PLUGSETTING: y3owk1n/undo-glow.nvim
-- Thanks to: https://zenn.dev/vim_jp/articles/00e297fcccf949
-- 初期化 色などはsetup引数で調整可能
local undo_glow = require('undo-glow')
undo_glow.setup({
  animation = {
    enabled = true,
    duration = 300,
    animation_type = "zoom",
    window_scoped = true,
  },
  highlights = {
    undo = {
      hl_color = { bg = "#693232" }, -- Dark muted red
    },
    redo = {
      hl_color = { bg = "#2F4640" }, -- Dark muted green
    },
    yank = {
      hl_color = { bg = "#7A683A" }, -- Dark muted yellow
    },
    paste = {
      hl_color = { bg = "#325B5B" }, -- Dark muted cyan
    },
    search = {
      hl_color = { bg = "#5C475C" }, -- Dark muted purple
    },
    comment = {
      hl_color = { bg = "#7A5A3D" }, -- Dark muted orange
    },
    cursor = {
      hl_color = { bg = "#793D54" }, -- Dark muted pink
    },
  },
  priority = 2048 * 3,
})
-- u/Uでundo/redo
vim.keymap.set('n', 'u', undo_glow.undo, { desc = 'Undo with highlight' })
vim.keymap.set('n', '<C-r>', undo_glow.redo, { desc = 'Redo with highlight' })
vim.keymap.set('n', 'p', undo_glow.paste_below, { desc = 'Paste below with highlight' })
vim.keymap.set('n', 'P', undo_glow.paste_above, { desc = 'Paste above with highlight' })

-- PLUGSETTING: sirasagi62/toggle-cheatsheet.nvim
-- プラグインのロード
local tcs = require('toggle-cheatsheet').setup(true)

-- チートシートを定義する
local cs1 = tcs.createCheatSheetFromSubmodeKeymap(
  tcs.conf {
    { "h", "←" },
    { "j", "↓" },
    { "k", "↑" },
    { "l", "→" },
    { "gg", "Go to the top" },
    { "G", "Go to the bottom" },
    { "%", "Go to matching bracket" }
  }
)

-- 別のチートシートを定義する。ただのテキストでも問題ない。
-- 日本語が含まれていても問題ない
local cs2 = [[
\zs, \ze -> マッチ境界
/vim/e   -> 検索のマッチの末尾にカーソルを移動する

'<,'>g/{pattern}/d -> 範囲内のマッチ行を削除する
'<,'>v/{pattern}/d -> 範囲内のマッチ行以外を削除する

visual 時に _ -> 無名レジスタを汚さず置換できる（プラグイン依存）

<Space>d  -> hidden buffer をすべて閉じる
<Space>D  -> すべての buffer を閉じる
<Space>bd -> fzf で選択した buffer を閉じる

<Space>[gG][dD] -> G なら全体、D なら staged で git diff

<Space>tj -> normal mode 時に json format をトグルする
<Space>tw -> カーソル上の英単語の意味を表示する
<Space>tp -> visual 範囲の英和翻訳を float 表示する
<Space>ty -> visual 範囲の英和翻訳をヤンクする

:%s/検索パターン/[&]/g -> 検索パターンを [] で囲む

:Octo pr list
    <leader>cr -> リプライを書く
    <C-b>      -> ブラウザで PR を開く
:Octo review {PR 番号}
    <leader><space> -> review 済みかどうかのトグル
    <leader>ca      -> コメントを追加する
:Octo review thread
    q -> 元のモードに戻る
:Octo review commit
:Octo pr commits
:Octo review submit

capture or .org
cit         -> 状態を変更(space で外す)
<Space>or   -> refile（fzf-lua で宛先を fuzzy 検索）
<Space>ot   -> project などのタグ付与
<Space>oid  -> 締切を付与
<Space>ois  -> 着手予定日を付与
<Space>o,   -> 優先度を付与
<Space>oz   -> アーカイブ（archive/ 配下に追い出す）
<C-c>       -> 確定
<Space>ok   -> キャンセル

agenda
t           -> 状態を変更(space で外す)
]]

-- 適当なキーにマッピング
-- 例ではkeymapを使っていますがコマンドでも問題なく動作するはずです

-- vim.keymap.set("n","<Leader>q",function()
--     tcs.toggle(cs1)
-- end)
vim.keymap.set("n", "<Leader>?", function()
  tcs.toggle(cs2)
end)

-- PLUGSETTING: gbprod/yanky.nvim
require("yanky").setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
})
-- vim.keymap.set("n", "<Space>pp", "<cmd>YankyRingHistory<CR>", { desc = "" })

-- PLUGSETTING: windwp/nvim-spectre
require('spectre').setup({
  -- open_cmd = function()
  --   local height = math.floor(vim.o.lines * 0.7) -- 70% の高さを計算
  --   -- vim.cmd('topleft ' .. height .. 'new') -- 横幅全体を使って split する
  --   vim.cmd(height .. 'new') -- 現在のウィンドウ幅を維持して水平分割
  -- end,
  mapping = {
    ['enter_file_and_close'] = {
      map = '<cr>',
      cmd = "<cmd>lua require('spectre.actions').select_entry(); require('spectre').close()<CR>",
      desc = 'open file and close spectre',
    },
    ['enter_file'] = {
      map = "o",
      cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
      desc = "open file"
    },
  },
})

-- PLUGSETTING: nvim-neotest/neotest

-- -------------------------------------------------------
-- nvim-treesitter
-- -------------------------------------------------------
-- require("nvim-treesitter.configs").setup({
--   ensure_installed = { "go" },
--   highlight = { enable = true },
-- })

-- -------------------------------------------------------
-- neotest-golang アダプターの設定
-- -------------------------------------------------------
local neotest_golang = require("neotest-golang")

-- -------------------------------------------------------
-- neotest 本体の設定
-- -------------------------------------------------------
require("neotest").setup({
  adapters = {
    neotest_golang({
      go_test_args = {
        "-v",
        "-count=1",
        "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
      },
    }),
  },
})

-- -------------------------------------------------------
-- nvim-coverage の設定
-- -------------------------------------------------------
require("coverage").setup({
  auto_reload = true,
  highlights = {
    covered   = { fg = "#4db300" },
    uncovered = { fg = "#ea6633" },
  },
  signs = {
    covered   = { hl = "CoverageCovered", text = "┃" },
    uncovered = { hl = "CoverageUncovered", text = "╎" },
  },
  summary = {
    min_coverage = 80.0,
  },
})

-- -------------------------------------------------------
-- キーマップ
-- -------------------------------------------------------
local neotest = require("neotest")
local coverage = require("coverage")

-- テスト実行系
vim.keymap.set("n", "<leader>tn", function() neotest.run.run() end,
  { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end,
  { desc = "Run tests in file" })
vim.keymap.set("n", "<leader>ta", function() neotest.run.run(vim.fn.getcwd()) end,
  { desc = "Run all tests" })
vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end,
  { desc = "Toggle test summary" })
vim.keymap.set("n", "<leader>to", function() neotest.output.open({ enter = true }) end,
  { desc = "Open test output" })

-- カバレッジ表示系
vim.keymap.set("n", "<leader>cl", function() coverage.load(true) end,
  { desc = "Load and show coverage" })
vim.keymap.set("n", "<leader>cs", function() coverage.summary() end,
  { desc = "Coverage summary" })
vim.keymap.set("n", "<leader>ch", function() coverage.hide() end,
  { desc = "Hide coverage" })

-- ORIGINAL:
local function blink_active_window(duration, count)
  local win = vim.api.nvim_get_current_win()
  local original = vim.api.nvim_win_get_option(win, "winhighlight")
  -- 柔らかい色を使う（例: Visual）
  local blink_hl = "Normal:Visual"
  for i = 1, count do
    vim.api.nvim_win_set_option(win, "winhighlight", blink_hl)
    vim.cmd("redraw")
    vim.wait(duration * 500)
    vim.api.nvim_win_set_option(win, "winhighlight", original)
    vim.cmd("redraw")
    vim.wait(duration * 500)
  end
end

vim.api.nvim_create_user_command("BlinkWindow", function()
  blink_active_window(0.5, 1)
end, {})

vim.api.nvim_set_keymap("n", "ss", "<cmd>BlinkWindow<cr>", { noremap = true, silent = true })

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- PLUGSETTING: mason.nvim + nvim-lspconfig
-- -------------------------------------------------------
-- キーマップ（LSP バッファアタッチ時に設定）
-- -------------------------------------------------------
local function on_attach(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- 診断ナビ（coc の [g / ]g に相当）
  vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)

  -- コードナビゲーション（coc の gd / gH / gi / gr に相当）
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gH', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

  -- ホバー（coc の gh に相当）
  vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)

  -- シンボルリネーム（coc の <Space>rn に相当）
  vim.keymap.set('n', '<Space>rn', vim.lsp.buf.rename, opts)

  -- コードアクション（coc の <Space>a / <Space>ac に相当）
  vim.keymap.set({ 'n', 'x' }, '<Space>a', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<Space>ac', vim.lsp.buf.code_action, opts)

  -- フォーマット（coc の <Space>f に相当）
  -- conform.nvim が担当し、設定のない filetype は LSP format にフォールバックする
  vim.keymap.set({ 'n', 'x' }, '<Space>f', function()
    require('conform').format({ async = true, lsp_format = 'fallback' })
  end, opts)

  -- コードレンズ（coc の <Space>cl に相当）
  vim.keymap.set('n', '<Space>cl', vim.lsp.codelens.run, opts)

  -- カーソル下のシンボルをハイライト（coc の CursorHold highlight に相当）
  local augroup_id = vim.api.nvim_create_augroup('lsp_document_highlight_' .. bufnr, { clear = true })
  vim.api.nvim_create_autocmd('CursorHold', {
    group = augroup_id,
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    group = augroup_id,
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })
end

-- -------------------------------------------------------
-- mason.nvim の初期化
-- -------------------------------------------------------
require('mason').setup()

-- LSP サーバー以外（リンター・フォーマッター等）の自動インストール
-- mason-lspconfig は LSP サーバー専用のため、それ以外は Mason の Lua API で管理する
local function mason_ensure_installed(packages)
  local registry = require('mason-registry')
  registry.refresh(function()
    for _, name in ipairs(packages) do
      local ok, pkg = pcall(registry.get_package, name)
      if ok and not pkg:is_installed() then
        pkg:install()
      end
    end
  end)
end

mason_ensure_installed({
  'golangci-lint',
})

-- -------------------------------------------------------
-- mason-lspconfig: 必要な LSP サーバーを自動インストール
-- -------------------------------------------------------
require('mason-lspconfig').setup({
  ensure_installed = {
    'gopls',  -- Go
    'ts_ls',  -- TypeScript / JavaScript
    'bashls', -- bash / zsh
    'vimls',  -- Vim script
    'lua_ls', -- Lua
  },
  automatic_installation = true,
})

-- -------------------------------------------------------
-- nvim-lspconfig: 各言語サーバーの設定 (Neovim 0.11+ / lspconfig v3.x API)
-- nvim-lspconfig がサーバーのデフォルト設定を vim.lsp.config に登録するため、
-- require('lspconfig').xxx.setup() は不要。vim.lsp.config で上書きするだけでよい。
-- -------------------------------------------------------
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Go
vim.lsp.config('gopls', {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
    },
  },
})

-- TypeScript / JavaScript
vim.lsp.config('ts_ls', {
  capabilities = capabilities,
  on_attach = on_attach,
})

-- bash / zsh
vim.lsp.config('bashls', {
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Vim script
vim.lsp.config('vimls', {
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Lua
-- workspace.library で Neovim 組み込みの API（vim.lsp.* 等）を認識させる
vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- サーバーを有効化
vim.lsp.enable({ 'gopls', 'ts_ls', 'bashls', 'vimls', 'lua_ls' })

-- -------------------------------------------------------
-- 診断表示の設定
-- -------------------------------------------------------
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- -------------------------------------------------------
-- PLUGSETTING: conform.nvim
-- -------------------------------------------------------
require('conform').setup({
  -- 保存時に自動フォーマット
  format_on_save = {
    timeout_ms = 2000,
    -- conform に設定のない filetype は LSP format にフォールバックする
    lsp_format = 'fallback',
  },

  formatters_by_ft = {
    go              = { 'goimports' },
    javascript      = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescript      = { 'prettier' },
    typescriptreact = { 'prettier' },
    css             = { 'prettier' },
    vue             = { 'prettier' },
    json            = { 'prettier' },
    html            = { 'prettier' },
  },

  formatters = {
    prettier = {
      -- プロジェクトにローカルの prettier バイナリまたは設定ファイルがある場合のみ実行する
      condition = function(_, ctx)
        return vim.fs.find({
          '.prettierrc',
          '.prettierrc.json',
          '.prettierrc.js',
          '.prettierrc.cjs',
          '.prettierrc.yaml',
          '.prettierrc.yml',
          'prettier.config.js',
          'prettier.config.cjs',
          'prettier.config.mjs',
          'node_modules/.bin/prettier',
        }, { path = ctx.filename, upward = true })[1] ~= nil
      end,
    },
  },
})

-- -------------------------------------------------------
-- PLUGSETTING: nvim-lint
-- -------------------------------------------------------
local lint = require('lint')

-- ESLint: プロジェクトローカルのバイナリを優先して使う
lint.linters.eslint.cmd = function()
  local found = vim.fs.find('node_modules/.bin/eslint', {
    upward = true,
    path = vim.fn.expand('%:p:h'),
  })
  return #found > 0 and found[1] or 'eslint'
end

lint.linters_by_ft = {
  javascript      = { 'eslint' },
  javascriptreact = { 'eslint' },
  typescript      = { 'eslint' },
  typescriptreact = { 'eslint' },
  vue             = { 'eslint' },
  go              = { 'golangcilint' },
}

-- リント実行のトリガー
vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
  callback = function()
    local ft = vim.bo.filetype

    -- JS/TS/Vue: プロジェクトに eslint 設定またはローカルバイナリがある場合のみ実行
    if vim.tbl_contains({ 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' }, ft) then
      local eslint_found = vim.fs.find({
        '.eslintrc', '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.json',
        '.eslintrc.yaml', '.eslintrc.yml',
        'eslint.config.js', 'eslint.config.mjs', 'eslint.config.cjs',
        'node_modules/.bin/eslint',
      }, { upward = true, path = vim.fn.expand('%:p:h') })
      if #eslint_found > 0 then
        lint.try_lint()
      end
      return
    end

    -- Go: 無条件で実行（golangci-lint は常に PATH にある前提）
    if ft == 'go' then
      lint.try_lint()
    end
  end,
})

-- -------------------------------------------------------
-- PLUGSETTING: obsidian-nvim/obsidian.nvim
-- -------------------------------------------------------
require("obsidian").setup {
  legacy_commands = false,
  workspaces = {
    {
      name = "personal",
      path = "~/go/src/github.com/maguroguma/diary", -- 自分の vault のパスに変更
    },
  },
  picker = {
    name = "fzf-lua", -- picker を使わない場合はこの行は不要
  },
  -- obsidian.nvim の追加 UI（チェックボックスや参照リンクの装飾）は使わない。
  -- これらは conceallevel が 1 以上でないと動かないが、この環境では
  -- render-markdown 側で conceallevel を 0 に固定しているため機能しない。
  -- false にしないと markdown を開くたびに警告が出る。
  ui = {
    enable = false,
  },
}

-- -------------------------------------------------------
-- PLUGSETTING: lambdalisue/nvim-aibo
-- -------------------------------------------------------
require('aibo').setup()
vim.keymap.set("n", "<leader>ai", '<cmd>Aibo -opener=rightbelow\\ vsplit claude --settings {"tui":"default"}<CR>',
  { desc = "open nvim-aibo by claude code" })

-- -------------------------------------------------------
-- PLUGSETTING: pwntester/octo.nvim
-- -------------------------------------------------------
require('octo').setup({
  picker = 'fzf-lua',
  reviews = {
    auto_show_threads = false,
  },
  mappings = {
    pull_request = {
      review_start = { lhs = "<localleader>rs", desc = "start a review for the current PR" }, -- error になるなら <localleader>vs で resume する
    },
    review_diff = {
      close_review_tab = { lhs = "" },
      review_commits = { lhs = "<localleader>rc", desc = "review PR commits" },
    },
    file_panel = {
      close_review_tab = { lhs = "" },
      review_commits = { lhs = "<localleader>rc", desc = "review PR commits" },
    },
    submit_win = {
      close_review_tab = { lhs = "" }, -- 注意: レビュー送信ウィンドウを閉じる操作も無効になります
    },
  },
})
vim.keymap.set("n", "<Space>op",
  '<cmd>Octo pr list<CR>',
  { desc = "Open PR list by octo.nvim" })

-- PLUGSETTING: nvim-orgmode/orgmode
-- taskpaper.vim からの移行先。taskpaper 側の設定は init.vim に残してあり、
-- 移行が完了したら削除する。
-- 注意: runtimepath への追加は init.vim 側で行っている（$VIMRUNTIME の
-- ftplugin/org.vim より前に置かないとキーマップが一切効かないため）。
local org_dir = vim.fn.expand("$GOPATH/src/github.com/maguroguma/diary/org")

-- org/ の直下は用途ごとのディレクトリだけを並べる。todo/ が現役のタスク、
-- journal/ が日報、unknowns/ が分からなかったことリストを受け持つ。
-- org_agenda_files が見るのは todo/ の直下だけなので、ここに置かない限り
-- アジェンダには載らない。用途を増やすときは、新しいディレクトリを切る。
local org_todo_dir = org_dir .. "/todo"

-- capture とアジェンダの宛先はここに集約する。ファイル名を変えるときはこの 5 行だけを直す。
local org_inbox_file = org_todo_dir .. "/inbox.org" -- capture の投入先。todo/ 直下が受信箱になる
local org_notes_file = org_todo_dir .. "/notes.org" -- タスクではないメモの置き場
local org_journal_dir = org_dir .. "/journal"       -- 日報。1 日 1 ファイルに分ける

-- 分からなかったことリスト。業務中に出会って調べきれなかった技術を放り込む。
-- 日報と同じく todo/ ではなく専用のディレクトリに置くのが肝で、org_agenda_files が
-- 「todo/ 直下の *.org」しか見ていないため、これだけでアジェンダ・週次レビュー・
-- 全 TODO 一覧のどれにも載らなくなる。TODO キーワードを付けても既存の一覧を汚さない。
-- 閲覧は下の org_agenda_custom_commands の u が、そのブロックだけ
-- org_agenda_files を上書きして担当する。
--
-- capture は必ず unknowns/inbox.org へ落とし、あとから unknowns/go.org のような
-- トピック別ファイルへ refile して振り分ける運用にする。そのための宛先候補は、
-- ファイル末尾の OrgCapture:get_destination() の override で合流させている。
local org_unknowns_dir = org_dir .. "/unknowns"
local org_unknowns_file = org_unknowns_dir .. "/inbox.org"

-- GTD の実践のコツ。アジェンダの本文末尾に薄く並べ、TODO を眺めるあいだ自然と目に
-- 入るようにする。extmark の仮想行なので実テキストは増えず、行数も <CR> の飛び先も
-- ずれない。アジェンダの操作は何も壊れない。
local org_gtd_tips = {
  "次に何をすべきかを明確にする — 次のアクションが曖昧だと、やる気が起きにくい",
  "行動にフォーカスする — いつ・どこで・どうやって実行するかまで考える",
  "着手できない理由を深掘りする — 意気込んでも動けないのは、ひっかかりがあるため",
  "とにかく収集して処理する — 認識できていないタスクが、じわじわ時間を奪う",
  "移譲できるものは移譲する — 自分がやる必要があるかを、そのつど問い直す",
}

local org_gtd_ns = vim.api.nvim_create_namespace("myconfig_org_gtd_tips")

-- 貼り直しの予約が二重に積まれるのを防ぐフラグ。バッファ番号をキーにする。
local org_gtd_pending = {}

--- アジェンダのバッファ末尾に、GTD のコツを薄い仮想行として貼り付ける。
--- 先頭に空行を 1 つ挟むのは、アジェンダ本文と地続きに見えるのを避けるため。
---@param bufnr integer 対象のバッファ番号
local function org_gtd_render_tips(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "orgagenda" then
    return
  end

  local virt_lines = { { { "", "Comment" } } }
  for _, tip in ipairs(org_gtd_tips) do
    table.insert(virt_lines, { { "  👺 " .. tip, "Comment" } })
  end

  -- 置き直す前に消すのは、末尾の行番号が変わったときに古い extmark が残らないようにするため
  vim.api.nvim_buf_clear_namespace(bufnr, org_gtd_ns, 0, -1)
  local ok, err = pcall(vim.api.nvim_buf_set_extmark, bufnr, org_gtd_ns,
    vim.api.nvim_buf_line_count(bufnr) - 1, 0, { virt_lines = virt_lines })
  if not ok then
    -- 表示だけの機能なので、失敗してもアジェンダの利用は続けられる。黙って諦めずに知らせる。
    vim.notify("GTD のコツを表示できませんでした: " .. tostring(err), vim.log.levels.WARN)
  end
end

--- アジェンダの再描画に追従できるよう、バッファの変更を監視して貼り直す。
--- nvim-orgmode は r や状態の変更のたびにバッファの行を丸ごと置き換え、その範囲の
--- extmark は消えるため、この貼り直しがないと一度きりの表示で終わってしまう。
---@param bufnr integer 対象のバッファ番号
local function org_gtd_watch_buffer(bufnr)
  if org_gtd_pending[bufnr] ~= nil then
    return -- 監視済み（nil でなければ attach 済みの印）
  end
  org_gtd_pending[bufnr] = false

  vim.api.nvim_buf_attach(bufnr, false, {
    -- on_lines の中では API を呼べない（textlock）ため、schedule で後回しにする。
    -- 1 回の描画で何度も発火するので、予約済みなら積み増さずに捨てる。
    on_lines = function()
      if org_gtd_pending[bufnr] then
        return
      end
      org_gtd_pending[bufnr] = true
      vim.schedule(function()
        org_gtd_pending[bufnr] = false
        org_gtd_render_tips(bufnr)
      end)
    end,
    on_detach = function()
      org_gtd_pending[bufnr] = nil
    end,
  })
end

-- BufWinEnter も拾うのは、同じバッファを別のウィンドウで開き直したときに
-- FileType が発火せず、コツが出ないままになるのを防ぐため。
vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
  callback = function(args)
    if vim.bo[args.buf].filetype ~= "orgagenda" then
      return
    end
    org_gtd_watch_buffer(args.buf)
    org_gtd_render_tips(args.buf)
  end,
})

-- 選択メニュー（agenda / capture / export / cit の fast access）を画面中央に出す。
-- 既定の実装は :echon + getchar() でコマンドライン領域に描くため、画面下部に出る。
-- ui.menu.handler は描画だけを差し替える口で、win_split_mode による
-- agenda / capture 本体のウィンドウ配置には影響しない。
--
-- 公式ドキュメントは vim.ui.select を使う例を載せているが、ここでは採用しない。
-- handler の戻り値はそのまま呼び出し元へ返る同期前提の設計で、cit（TODO fast
-- access）は選ばれたキーワードを返してもらう必要がある。非同期の vim.ui.select
-- だと常に nil が返り、cit が動かなくなる。
---@param data table nvim-orgmode から渡るメニュー定義（title / items / prompt / kind）
---@return any # 選ばれた項目の action() の戻り値。何も選ばれなければ nil
local function org_menu_popup(data)
  local lines = {}
  local separators = {}   -- 行番号 -> セパレータに使う文字（幅が決まってから埋める）
  local valid_keys = {}
  local option_lines = {} -- 行番号 -> メニュー項目（ハイライト用）

  table.insert(lines, data.title)
  separators[#lines + 1] = "-"
  table.insert(lines, "")

  -- 同じキーを持つ項目が複数あるとき、実際に発火するのは最後に登録されたもの。
  -- valid_keys が後勝ちで上書きされるためで、これは nvim-orgmode 本体の
  -- Menu:get_valid_keys() も同じ挙動になっている。
  -- org_agenda_custom_commands は組み込みのコマンドより後に積まれるので、
  -- 下の t のようにキーを奪うと、組み込み側の行が「押しても反応しない行」として
  -- 残ってしまう。表示と挙動を一致させるため、後勝ちで間引いてから描画する。
  local last_index_by_key = {}
  for index, item in ipairs(data.items) do
    if item.key then
      last_index_by_key[item.key] = index
    end
  end

  for index, item in ipairs(data.items) do
    if item.icon then
      -- セパレータは既定で length = 80 と長いので、幅はこちらで決め直す
      separators[#lines + 1] = item.icon
      table.insert(lines, "")
    elseif last_index_by_key[item.key] == index then
      valid_keys[item.key] = item
      option_lines[#lines + 1] = item
      table.insert(lines, string.format("%s  %s", item.key, item.label))
    end
  end

  -- data.prompt（"Template key" など）はウィンドウ内の title と内容が重複するため使わない
  local width = 20
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line) + 2)
  end
  width = math.min(width, vim.o.columns - 4)

  for lnum, icon in pairs(separators) do
    lines[lnum] = string.rep(icon, width)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local ns = vim.api.nvim_create_namespace("myconfig_org_menu")
  vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, { end_col = #lines[1], hl_group = "Title" })
  for lnum, item in pairs(option_lines) do
    -- 押すキーだけを目立たせ、ラベルは TODO キーワードの色（hl）があればそれに従う
    vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, 0, { end_col = #item.key, hl_group = "Question" })
    if item.hl then
      vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, #item.key + 2, {
        end_col = #lines[lnum],
        hl_group = item.hl,
      })
    end
  end
  vim.bo[buf].modifiable = false

  local height = math.min(#lines, vim.o.lines - 4)
  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = width,
    height = height,
    row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1),
    col = math.max(0, math.floor((vim.o.columns - width) / 2)),
    style = "minimal",
    border = "rounded",
    noautocmd = true,
  })

  vim.cmd("redraw")
  -- <C-c> で getcharstr() が例外を投げるため、pcall で受けてウィンドウを必ず閉じる
  local ok, char = pcall(vim.fn.getcharstr)
  vim.api.nvim_win_close(win, true)
  vim.cmd("redraw")

  if not ok then
    return
  end
  local entry = valid_keys[char]
  if not entry or not entry.action then
    return
  end
  return entry.action()
end

-- タスクの「状態」でワークフローを表現する。運用ルールは以下のとおり。
--   SOMEDAY … やるかどうかまだ決めていない。週次レビューで棚卸しする
--   TODO    … やると決めたが、着手できる粒度に分解できていない（＝分解待ち）
--   NEXT    … 分解済みで、いま着手できる「次の一手」
--   GOING   … 着手中（taskpaper の @inProgress）
--   WAIT    … 他者・外部要因の待ちでブロックされている（taskpaper の @wait）
--   DONE    … 完了
--   CANCELED… 棄却。「終わった」扱いにして DONE と区別する
-- 「手をつけられる粒度になったら即 NEXT にする」を守ることで、TODO のまま残って
-- いるものが「分解待ちの大きなタスク」として自動的に炙り出される。
--
-- 並び順にも意味がある。アジェンダの todo-state-down はこの定義順を逆にたどるため、
-- 下に置いたキーワードほど一覧の上に来る（下の T のカスタムコマンドを参照）。
local org_todo_keywords = {
  "SOMEDAY(s)",
  "TODO(t)",
  "NEXT(n)",
  "GOING(g)",
  "WAIT(w)",
  "|",
  "DONE(d)",
  "CANCELED(c)",
}

--- 「状態が付いていない見出し」だけを拾うアジェンダの match クエリを組み立てる。
---
--- nvim-orgmode は検索時、キーワードを持たない見出しの状態を空文字として扱う。
--- そのため全キーワードを `-` で否定すると、どれにも一致しない空文字だけが生き残る。
--- 未完了キーワードだけを否定すると DONE / CANCELED が残ってしまうので、
--- `|` を除く全てのキーワードを並べる必要がある。
---
---@param keywords string[] org_todo_keywords と同じ形式（`KEYWORD(x)` と `|` を含む）
---@return string query tags 型のアジェンダに渡す match クエリ
local function build_no_keyword_query(keywords)
  local query = "/"
  for _, keyword in ipairs(keywords) do
    if keyword ~= "|" then
      -- "SOMEDAY(s)" のような fast access 用の括弧を落として "SOMEDAY" にする
      local value = keyword:gsub("%b()", "")
      query = query .. "-" .. value
    end
  end
  return query
end

local org_no_keyword_query = build_no_keyword_query(org_todo_keywords)

require("orgmode").setup {
  -- diary リポジトリの中の org/todo/ だけを、アジェンダの対象として隔離する。
  -- * は 1 階層しか展開しないので、todo/archive/ 配下は走査されず、
  -- アジェンダには現役のタスクだけが並ぶ。journal/ と unknowns/ が
  -- 載らないのも同じ理屈で、ここに書いたディレクトリの外にあるため。
  org_agenda_files = { org_todo_dir .. "/*.org" },
  -- capture の投入先は inbox.org に統一し、その「直下（トップレベル）」を受信箱として使う。
  -- 親にぶら下げたくなったら <Space>or で同じファイルの中を移動させればよく、
  -- 受信箱専用のファイルを別に持つ必要がない。
  -- この設定自体は、target を書いていない capture テンプレートの既定の宛先。
  -- 下の org_capture_templates は全て target を明示しているので、実際には
  -- :checkhealth orgmode の警告を消すための保険として効いている。
  org_default_notes_file = org_inbox_file,

  -- キーワードの一覧と運用ルールは、setup の手前の org_todo_keywords を参照。
  -- 「状態未設定の見出し」を集めるクエリを組み立てる都合で、外に出している。
  org_todo_keywords = org_todo_keywords,
  org_todo_keyword_faces = {
    SOMEDAY = ":foreground #928374 :slant italic",
    NEXT = ":foreground #b57614 :weight bold",  -- 次の一手が一番目立つようにする
    GOING = ":foreground #79740e :weight bold", -- 旧 @inProgress の色
    WAIT = ":foreground #076678 :weight bold",  -- 旧 @wait の色
    CANCELED = ":foreground #928374 :slant italic",
  },

  -- 優先度を既定の A〜C から A〜E の 5 段階に広げる。
  -- highest（A）と default（B）は既定のまま据え置き、lowest だけを E にずらす。
  -- nvim-orgmode は highest から lowest までを文字コード順にたどって範囲を作るので、
  -- 増減（cir など）も直接入力もこの 1 行で A〜E を扱えるようになる。
  -- default を B に残しているのは、優先度を持たない見出しのソート位置を変えないため。
  -- 区分が変わる（C が lowest から low になる）ので、下の @org.priority.* の色も対になっている。
  -- 3 つは必ず揃えて書く。lowest だけを指定すると
  -- 「can only be set together」の警告が出て、A〜C の既定に戻されてしまう。
  org_priority_highest = "A",
  org_priority_default = "B",
  org_priority_lowest = "E",

  -- @done(YYYY-MM-DD) 相当。DONE / CANCELED にした日時を CLOSED: として自動で残す
  org_log_done = "time",
  org_log_into_drawer = "LOGBOOK",

  -- 自作していた due ハイライト（critical_days / warning_days）の代替。
  -- この日数以内の DEADLINE がアジェンダ上で警告扱いになる。
  org_deadline_warning_days = 7,

  -- taskpaper の Archive: セクション相当。
  -- inbox.org -> org/todo/archive/inbox.org_archive に退避する（相対パス指定）。
  -- 相対パスはアーカイブ元ファイルのあるディレクトリを基準に解決されるため、
  -- todo/ の中身をどこへ移しても、移した先の archive/ が自動的に使われる。
  -- 退避済みの見出しに残る :ARCHIVE_FILE: は記録専用で、読み取る実装はない。
  -- 過去のパス（org/todo.org など）が残っていても実害は出ない。
  org_archive_location = "archive/%s_archive::",

  -- 分解した親見出しには状態を付けず、:project: タグだけを付ける運用にする。
  -- 継承から除外することで、配下のタスクが +project にヒットしなくなり、
  -- 「プロジェクトそのもの」だけを週次レビューで一覧できる。
  --
  -- 状態を付けない狙いは、built-in の t（全 TODO エントリ）に載せないことにある。
  -- プロジェクトは「望む結果」であって、そのままでは手を動かせないため、
  -- 次の一手を選ぶための一覧に並べても判断コストが増えるだけになる。
  -- 代わりに、下の w（週次レビュー）の +project ブロックが唯一の窓口になる。
  --
  -- プロジェクトの投入口は capture の p。途中で「これは分解が必要な塊だ」と
  -- 気づいた場合は、cit で fast access を開いて Space（Clear keyword）を押すと
  -- 状態を外せるので、そこから <Leader>ot で :project: タグを付けて昇格させる。
  --
  -- 状態を持たない以上、プロジェクトを DONE で閉じることはできない。
  -- 配下が全て DONE になった時点でアーカイブする操作が、実質的な締めになる。
  org_tags_exclude_from_inheritance = { "project" },

  -- アジェンダと capture のウィンドウを、画面の上半分ちょうどに開く。
  -- 既定の "horizontal" は行数を直接指定するため（アジェンダ 34 行、capture 16 行）、
  -- 画面の高さによって広すぎたり狭すぎたりする。:split は現在のウィンドウを
  -- 半分に割る挙動なので、topleft と組み合わせて「上半分」を得る。
  win_split_mode = "topleft split",

  org_startup_folded = "content",
  -- 効かないのでコメントアウトしている。*bold* などの記号を隠すには
  -- conceallevel を 1 以上にする必要があるが、この環境は 0（render-markdown 側でも
  -- 明示的に 0 にしている）ため、true にしても何も起きない。
  -- 記号を隠したくなったら、この行を戻した上で org ファイルの conceallevel を上げる。
  -- org_hide_emphasis_markers = true,
  org_tags_column = 0, -- taskpaper のようにタグを本文の直後に置く
  -- 深いツリーを読みやすくするための仮想インデント。見出しの先頭の * も隠れる。
  -- 見た目が好みでなければこの 1 行を消せば元に戻る。
  -- org_startup_indented = true,

  org_capture_templates = {
    t = {
      description = "Todo（分解待ちも含めて、まずはここに放り込む）",
      template = "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:",
      target = org_inbox_file,
    },
    d = {
      description = "Todo（期限付き。カレンダーで日付を選ぶ）",
      -- %^{...}t はカレンダーを開いて日付を選ばせる
      template = "* TODO %?\nDEADLINE: %^{期限}t\n:PROPERTIES:\n:CREATED: %U\n:END:",
      target = org_inbox_file,
    },
    s = {
      description = "Someday（やるかどうか未定のアイデア）",
      template = "* SOMEDAY %?\n:PROPERTIES:\n:CREATED: %U\n:END:",
      target = org_inbox_file,
    },
    n = {
      -- 既存タスクのサブタスクを作るとき用。capture ウィンドウで <Space>or を押すと
      -- 「inbox.org/親タスク名」を補完で選べて、そのまま子見出しとしてぶら下がる。
      description = "Next（サブタスク。<Space>or で親へぶら下げる）",
      template = "* NEXT %?\n:PROPERTIES:\n:CREATED: %U\n:END:",
      target = org_inbox_file,
    },
    p = {
      -- 分解待ちの「塊」を入れる口。ここだけ TODO キーワードを付けずに投入する。
      -- notes.org ではなく inbox.org に入れるのは、notes.org を「タスクではないもの」の
      -- 置き場として保ち、週次レビューで読む対象を inbox.org だけに閉じておくため。
      -- 期限はプロジェクト自体には持たせない。agenda ビューは TODO キーワードではなく
      -- 日付で拾うため、ここに DEADLINE を書くと d / w の日付ブロックに出続けてしまう。
      -- 期限は分解後の NEXT 側に付ける。
      description = "Project（分解待ちの塊。状態は持たせない）",
      template = "* %? :project:\n:PROPERTIES:\n:CREATED: %U\n:END:",
      target = org_inbox_file,
    },
    m = {
      description = "Memo（notes.org へ。タスクではないもの）",
      template = "* %?\n%U",
      target = org_notes_file,
    },
    -- キーはアジェンダ側の j（日報ビュー）と揃えてある。投入と閲覧で同じ文字を
    -- 叩けるようにして、日報まわりの操作を 1 文字で覚えられる状態に保つ。
    j = {
      -- 日報。1 日 1 ディレクトリに分け、journal/YYYY/MM/DD/index.org へ落とす。
      -- target に書いた %<...> は本文と同じく os.date で展開されるため、日付が
      -- 変わると宛先ファイルが自動的に切り替わる。存在しないファイルについては、
      -- capture が確認ダイアログを 1 回出した上で、親ディレクトリごと作ってくれる。
      -- mkdir は 'p' 付きで呼ばれるので、YYYY/MM/DD の 3 階層が一度に掘られる。
      --
      -- 日付そのものをディレクトリにしているのは、その日のスクショや貼り付けた
      -- コード片を本文の隣に置けるようにするため。本文を index.org に固定して
      -- おけば、ディレクトリの中でどれが日報本体かを迷わずに済む。
      --
      -- 置き場を journal/ 配下に分けているのは、org_agenda_files が todo/ 直下の
      -- *.org しか見ていないため。日報は「済んだことのログ」であってタスクではなく、
      -- アジェンダや週次レビューに並べても次の一手を選ぶ役には立たない。
      -- 「レビューで読むのは inbox.org だけ」という状態を保つために、あえて拾わせない。
      --
      -- 見出しの下に %T（アクティブなタイムスタンプ）を置くのは、日報を下の j
      -- アジェンダへ載せるため。アジェンダは日付か TODO 状態を手がかりに見出しを
      -- 拾うので、パス側に日付があるだけでは並ばない。DEADLINE でも SCHEDULED でも
      -- ない素のタイムスタンプで十分に拾われる。
      --
      -- 見出しそのものには時刻を入れない。%T が時刻まで含むため、入れると同じ時刻が
      -- 1 エントリに 2 度出て冗長になる。アジェンダ側もタイムスタンプから時刻を読んで
      -- 行頭に出してくれるので、見出しは本文だけに保つ。
      description = "日報（journal/YYYY/MM/DD/index.org へ積む）",
      template = "* %?\n%T",
      target = org_journal_dir .. "/%<%Y/%m/%d>/index.org",
    },
    -- キーは日報の j と同じ考え方で、アジェンダ側の u（分からなかったこと）と揃えてある。
    -- 投入と閲覧で同じ 1 文字を叩けるようにして、操作を覚える負担を減らす。
    u = {
      -- 分からなかったこと。業務の手を止めずに放り込めることを最優先する。
      -- 投入先は unknowns/inbox.org に固定し、トピック別ファイルへの振り分けは
      -- あとから refile でやる。capture の時点で宛先を選ばせると、その判断コストで
      -- 「とりあえず放り込む」というこのテンプレートの目的が崩れてしまう。
      --
      -- TODO キーワードを付けるのは、調べて分かった時点で DONE にして締められる
      -- ようにするため。unknowns/ は org_agenda_files の外にあるので、TODO を
      -- 付けても d / w / t の一覧には流れ込まない。
      --
      -- CREATED を残すのは、「いつ出会ったか」が後から効く情報だから。
      -- 半年放置されている項目は、実は困っていなかったと判断して捨てられる。
      description = "分からなかったこと（unknowns/inbox.org へ積む）",
      template = "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:",
      target = org_unknowns_file,
    },
  },

  org_agenda_custom_commands = {
    -- 日次: いま手を動かせるものだけに絞る。TODO / SOMEDAY はあえて出さない。
    d = {
      description = "日次ダッシュボード",
      types = {
        { type = "agenda", org_agenda_span = "day", org_agenda_overriding_header = "今日（期限・予定）" },
        { type = "tags_todo", match = "/GOING", org_agenda_overriding_header = "着手中" },
        { type = "tags_todo", match = "/NEXT", org_agenda_overriding_header = "次の一手" },
        { type = "tags_todo", match = "/WAIT", org_agenda_overriding_header = "待機中（ブロック中）" },
      },
    },
    -- 日報: その日に capture したログだけを一覧する。<TAB> でその日のファイルへ飛べるので、
    -- capture の UI を確定させたあとに続きを書き足したくなったときの入口になる。
    --
    -- org_agenda_files をこのブロックだけに指定しているのがこの定義の肝。
    -- グローバルの org_agenda_files（todo/ 直下の *.org）は据え置いたまま、この
    -- ビューだけが journal/ 配下を見る。こうしないと日報が d や w にも流れ込み、
    -- 「次の一手を選ぶ一覧」がログで埋まってしまう。
    -- ** は vim.fn.glob に渡るため、YYYY/MM/DD の階層を跨いで再帰的に展開される。
    -- 深さを問わず拾うので、旧レイアウト（YYYY/MM/DD.org）が残っていても一緒に並ぶ。
    j = {
      description = "日報（今日書いたログ）",
      types = {
        {
          type = "agenda",
          org_agenda_span = "day",
          org_agenda_files = { org_journal_dir .. "/**/*.org" },
          org_agenda_overriding_header = "今日の日報",
        },
      },
    },
    -- 分からなかったこと: 未解決のものだけを一覧する。capture の u と対になる入口。
    --
    -- 日報の j と同じく、このブロックだけ org_agenda_files を unknowns/ に向けている。
    -- グローバルの org_agenda_files（todo/ 直下の *.org）は据え置かれるので、ここに
    -- 並ぶ TODO が d（日次）や w（週次レビュー）へ漏れることはない。「業務で手を
    -- 動かすためのタスク」と「あとで調べたい技術」は緊急度の性質が違うので、
    -- 同じ一覧に混ぜると次の一手を選ぶ判断が鈍る。
    --
    -- tags_todo に match = "" を渡すのは「条件なしで未完了を全件」の意味で、
    -- 下の t（全 TODO）と同じ書き方をしている。DONE にしたものは自動的に落ちるため、
    -- 調べ終えた項目は何もしなくても一覧から消える。
    --
    -- glob を */*.org ではなく **/*.org にしてあるのは、トピックが増えて
    -- unknowns/go/generics.org のように階層を切りたくなったときに、設定を
    -- 直さずそのまま拾えるようにするため。
    u = {
      description = "分からなかったこと（未解決）",
      types = {
        {
          type = "tags_todo",
          match = "",
          org_agenda_files = { org_unknowns_dir .. "/**/*.org" },
          org_agenda_overriding_header = "分からなかったこと（調べたら DONE にする）",
        },
      },
    },
    -- 週次レビュー: 溜まっているものを棚卸しする。ここが分解と棄却の場。
    w = {
      description = "週次レビュー",
      types = {
        { type = "tags", match = "+project", org_agenda_overriding_header = "プロジェクト一覧（NEXT が 1 つあるか確認する）" },
        { type = "tags_todo", match = "/TODO", org_agenda_overriding_header = "分解待ち（NEXT を切るか、CANCELED にする）" },
        { type = "tags_todo", match = "/SOMEDAY", org_agenda_overriding_header = "いつかやる（やらないと決めたら CANCELED）" },
        { type = "tags_todo", match = "/WAIT", org_agenda_overriding_header = "待機中（待ち続けていないか確認する）" },
        { type = "tags_todo", match = '+PRIORITY="A"', org_agenda_overriding_header = "緊急（旧 @urgent）" },
        { type = "tags_todo", match = "+risky", org_agenda_overriding_header = "不確実（旧 @risky）" },
        { type = "agenda", org_agenda_span = "week", org_agenda_overriding_header = "今週" },
      },
    },
    -- 掃除用: 完了・棄却したものだけを集めて、その場で <Space>oz を連打して追い出す。
    -- tags_todo は未完了しか拾わないため、DONE を含められる tags を使う。
    -- :ARCHIVE: タグ付きと archive/ 配下は検索対象から外れるので、処理済みは並ばない。
    z = {
      description = "アーカイブ候補（DONE / CANCELED）",
      types = {
        {
          type = "tags",
          match = "/DONE|CANCELED",
          org_agenda_overriding_header = "アーカイブ候補（<Space>oz で追い出す）",
        },
      },
    },
    -- 全 TODO（状態順）: 常用するため、組み込みの t からキーを奪って t に置く。
    -- カスタムコマンドは組み込みのコマンドより後にメニューへ積まれ、キーは
    -- 後勝ちで解決されるので、この定義がそのまま t の担当になる。
    -- 押せなくなった組み込みの行は、org_menu_popup 側で間引いている。
    -- 元の t（優先度順）は、下の T として同じ内容を組み直してある。
    --
    -- todo-state-down は org_todo_keywords の定義順を逆にたどるため、定義順が
    -- SOMEDAY → TODO → NEXT → GOING → WAIT である以上、一覧は
    -- WAIT → GOING → NEXT → TODO → SOMEDAY となり、手を動かせるものが上に来る。
    -- 定義順そのものを組み替えても同じ並びは作れるが、それをすると
    -- <prefix>iT で挿入される見出しのキーワードまで変わってしまう。
    -- 副作用を避けるため、定義順は据え置いて逆順ソートで解決している。
    -- 同じ状態の中では優先度の高い順、それも同じならファイル順・出現順に並ぶ。
    t = {
      description = "全 TODO（状態順）",
      types = {
        {
          -- カスタムコマンドは組み込みの t と同じ type = "todo" を受け付けない。
          -- ただし tags_todo は todo_only を立てるので、対象の見出しは t と一致する。
          -- match が空文字のときは「条件なし」として扱われ、全件が残る。
          type = "tags_todo",
          match = "",
          org_agenda_sorting_strategy = { "todo-state-down", "priority-down", "category-keep" },
          org_agenda_overriding_header = "全 TODO（状態順 → 優先度順）",
        },
      },
    },
    -- 組み込みの t の代替。t を上の状態順に譲ったので、優先度順の一覧をここへ移す。
    -- 組み込みの todo ビューの既定ソートが priority-down / category-keep なので、
    -- 同じ戦略を明示すれば見え方は元の t と変わらない。
    T = {
      description = "全 TODO（優先度順・元の t）",
      types = {
        {
          type = "tags_todo",
          match = "",
          org_agenda_sorting_strategy = { "priority-down", "category-keep" },
          org_agenda_overriding_header = "全 TODO（優先度順）",
        },
      },
    },
    -- 状態未設定の見出し: capture したまま状態を付け忘れたものを拾う。
    -- :project: を付けた見出しは元から状態を持たない運用なので、ここには必ず並ぶ。
    -- プロジェクトを除いて見たいときは、アジェンダ上で / を押して -project で絞れる。
    n = {
      description = "状態未設定の見出し",
      types = {
        {
          -- tags_todo ではなく tags を使う。tags は todo_only を立てないため、
          -- キーワードを持たない見出しが検索の対象に入る。
          type = "tags",
          match = org_no_keyword_query,
          org_agenda_overriding_header = "状態未設定の見出し（:project: を含む）",
        },
      },
    },
  },

  -- アーカイブ（org_archive_subtree）は既定が <prefix>$ で Shift を要求するため、
  -- Shift and Space 環境では leader の <Space> と衝突して打ちにくい。
  -- 完了タスクをファイルから追い出す操作は多用するので、vim の fold（畳む）を
  -- 連想させる z に寄せて、非 Shift の単打で叩けるようにする。
  -- 一方 org_toggle_archive_tag（<prefix>A）はファイルに残す操作で出番が少ないため、
  -- 既定のまま据え置く。
  mappings = {
    prefix = "<Leader>o",
    org = { org_archive_subtree = "<prefix>z" },
    -- 確定の既定 <C-c> は、Emacs の org-capture の C-c C-c（確定）を縮めたもの。
    -- ところが vim の <C-c> は「キャンセル」を連想させるため、意味が逆に読める。
    -- 実際、挿入モードの <C-c> はモードを抜けるだけなので、中断のつもりで
    -- 2 回叩くと保存されて閉じる、という逆向きの事故が起きる。
    -- そこで kill（<prefix>k）や refile（<prefix>r）と系列を揃えて <prefix>c に寄せ、
    -- <C-c> は残さず外す。capture ウィンドウの中ではグローバルの capture 起動
    -- （同じ <prefix>c）を覆うが、capture を入れ子にはしないので実害はない。
    capture = { org_capture_finalize = "<prefix>c" },
    -- note バッファ（org_add_note など）の確定も既定が <C-c> なので揃える。
    note = { org_note_finalize = "<prefix>c" },
    -- プレビュー（既定 K）は、LSP hover に割り当てている gh と操作感を揃える。
    -- agenda バッファには LSP が attach せず、orgmode がバッファローカルに
    -- keymap を張るため、グローバルの gh とも衝突しない。
    agenda = {
      org_agenda_archive = "<prefix>z",
      org_agenda_preview = "gh",
      -- 日付ジャンプ（既定 J）は無効化する。J はグローバルで 10gj に
      -- 割り当てており、agenda 上でも同じ移動感を保ちたいため。
      -- false を渡すとその keymap は張られない（map_entry.lua の attach 参照）。
      org_agenda_goto_date = false,
    },
  },

  -- 選択メニューだけを中央のフロートに差し替える。
  -- ハンドラを設定すると cit（TODO fast access）もこちらを通る。
  ui = {
    menu = { handler = org_menu_popup },
  },
}

-- 見出しの priority（[#A] など）の色。
-- nvim-orgmode は queries/org/highlights.scm で priority の区分ごとに
-- @org.priority.{highest,high,default,low,lowest} を割り当てるが、色を持つのは
-- highest（@comment.error へのリンク）だけで、残りは未定義のため色がつかない。
-- そこでここで明示的に定義する。プラグイン側のリンクは default = true 付きなので、
-- ここでの指定が優先され、上書きされることはない。
-- setup で org_priority_lowest = "E" にしているため、区分は
-- A = highest、B = default、C・D = low、E = lowest に対応する（high は該当なし）。
-- 区分ごとに 1 色しか持てないので、C と D は同じ色になる。
--
-- A〜C の色は taskpaper.vim 時代（init.vim の g:task_paper_styles と
-- g:taskpaper_due_highlight）の見た目をそのまま引き継いでいる。
-- 目の慣れを保つため、背景色で塗る方式も含めて踏襲する。
-- 元々 C に付けていた緑は、C を含む low 区分へ移した。
-- 追加した E は「ほぼ手を付けない」位置づけなので、目立たない灰色にしている。
vim.api.nvim_set_hl(0, "@org.priority.highest", { bg = "#ff9999", fg = "#000000" }) -- A: 旧 DueCritical（@due の期限切れ）
vim.api.nvim_set_hl(0, "@org.priority.default", { bg = "#cccc00", fg = "#000000" }) -- B: 旧 @urgent / @risky
vim.api.nvim_set_hl(0, "@org.priority.low", { bg = "#87af87", fg = "#000000" })     -- C・D: 旧 @inProgress
vim.api.nvim_set_hl(0, "@org.priority.lowest", { bg = "#bdae93", fg = "#000000" })  -- E

-- 日報に紐づく markdown メモ。capture の j（index.org）とは別に、会議メモのような
-- まとまった記録を journal/YYYY/MM/DD/<タイトル>.md へ切り出すための仕組み。
-- nvim-orgmode の capture は org 形式でしか書き出せないので、自前で用意している。
--
-- md を作ると同時に、その日の index.org へ「見出し + アクティブなタイムスタンプ +
-- リンク」を 1 件積む。capture の j と同じ形にしておくことで、アジェンダの j
-- ビューにも scripts/org-timeline.sh にも、md メモが他の日報と並んで時系列に載る。
-- md 自体は org ではないのでどちらからも読まれず、index.org 側の 1 件が代理を務める。
--
-- リンクを file:./ の相対パスにしているのは、nvim の cwd に依存させないため。
-- nvim-orgmode は org ファイル自身のディレクトリを基準に解決するので、どこで
-- 開いた nvim からでも辿れる。

--- 今日の日報ディレクトリ（journal/YYYY/MM/DD）の絶対パスを返す。
--- 呼ばれた時点の日付で決まるため、日付を跨いだセッションでも宛先が追従する。
---@return string
local function journal_today_dir()
  return org_journal_dir .. os.date("/%Y/%m/%d")
end

--- 入力されたメモのタイトルを検証し、ファイル名として使える形に整える。
--- パス区切りや先頭のドットは、journal/ の外や隠しファイルへ書き出す事故を防ぐために拒否する。
---@param input string|nil vim.ui.input から渡る生の入力（中断時は nil）
---@return string|nil title 拡張子を除いたタイトル。不正・中断なら nil
---@return string|nil err 不正だった理由。中断時は nil
local function normalize_journal_memo_title(input)
  if input == nil then
    return nil, nil
  end
  local title = vim.trim(input):gsub("%.md$", "")
  if title == "" then
    return nil, "タイトルが空です"
  end
  if title:find("[/\\%z]") or title:find("^%.") or title:find("[%[%]\n]") then
    -- [ ] は org のリンク記法 [[file:...][...]] を壊すので、ここで弾いておく
    return nil, "タイトルに / \\ [ ] や先頭の . は使えません: " .. title
  end
  return title, nil
end

--- index.org の末尾に md メモへのリンク見出しを追記して保存する。
--- 同じ nvim で index.org を開いていても W11（外部で変更された）警告が出ないよう、
--- ファイルを直接書き換えずにバッファ経由で追記する。
--- 未保存の変更があるときは、それを巻き込んで保存しないよう追記自体を見送る。
---@param index_path string 追記先の index.org の絶対パス
---@param title string 見出しとリンクの表示名に使うタイトル
---@return boolean ok 追記して保存できたら true
---@return string|nil err 失敗した理由
local function append_journal_memo_link(index_path, title)
  local existed = vim.fn.bufexists(index_path) == 1
  local was_loaded = vim.fn.bufloaded(index_path) == 1
  local bufnr = vim.fn.bufadd(index_path)
  vim.fn.bufload(bufnr)
  if vim.bo[bufnr].modified then
    return false, "index.org に未保存の変更があるため、リンクの追記を見送りました"
  end

  --- 追記のためだけに読み込んだバッファを、バッファ一覧から消す。
  --- 失敗時は追記を戻してから呼ぶが、万一変更が残っていても隠れた未保存バッファに
  --- ならないよう force で消す（ディスク上の index.org には影響しない）。
  local function cleanup()
    if not existed then
      pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
    end
  end

  -- bufload は読み込み済みのバッファをディスクから読み直さない。tmux の別ペインの
  -- nvim で capture j を積んだ後だと、古い内容に追記して保存することになり、
  -- 別ペインで積んだ日報を消してしまう。直前で未変更を確認済みなので、
  -- edit! で読み直しても手元の編集は失われない。
  if was_loaded and vim.fn.filereadable(index_path) == 1 then
    local reloaded, reload_err = pcall(vim.api.nvim_buf_call, bufnr, function()
      vim.cmd("silent edit!")
    end)
    if not reloaded then
      return false, "index.org を読み直せなかったため、リンクの追記を見送りました: " .. tostring(reload_err)
    end
  end

  local lines = {
    "* " .. title,
    require("orgmode.objects.date").now():to_wrapped_string(true),
    string.format("  [[file:./%s.md][%s]]", title, title),
  }
  -- 空のファイルは 1 行の空行として読まれるので、その場合は先頭から置き換える
  local last = vim.api.nvim_buf_line_count(bufnr)
  local is_empty = last == 1 and vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] == ""
  local start = is_empty and 0 or last
  vim.api.nvim_buf_set_lines(bufnr, start, -1, false, lines)

  local ok, err = pcall(vim.api.nvim_buf_call, bufnr, function()
    vim.cmd("silent write")
  end)
  if not ok then
    -- 追記した行を戻して、読み込み直後（＝ディスクと同じ）状態に揃える。
    -- 残すと未保存バッファになり、次回の追記が「未保存の変更あり」で弾かれ続ける。
    vim.api.nvim_buf_set_lines(bufnr, start, -1, false, is_empty and { "" } or {})
    vim.bo[bufnr].modified = false
    cleanup()
    return false, "index.org の保存に失敗しました: " .. tostring(err)
  end
  cleanup()
  return true, nil
end

--- タイトルを尋ねて、今日の日報ディレクトリに markdown メモを作って開く。
--- 既に同名のメモがあれば、index.org には何も足さずにそれを開くだけにする。
local function create_journal_memo()
  vim.ui.input({ prompt = "日報メモのタイトル: " }, function(input)
    local title, err = normalize_journal_memo_title(input)
    if not title then
      if err then
        vim.notify(err, vim.log.levels.WARN)
      end
      return
    end

    local dir = journal_today_dir()
    local memo_path = dir .. "/" .. title .. ".md"
    if vim.fn.filereadable(memo_path) == 1 then
      vim.cmd.edit(vim.fn.fnameescape(memo_path))
      return
    end

    if vim.fn.isdirectory(dir) == 0 and vim.fn.mkdir(dir, "p") == 0 then
      vim.notify("ディレクトリを作成できませんでした: " .. dir, vim.log.levels.ERROR)
      return
    end
    if vim.fn.writefile({ "# " .. title, "" }, memo_path) ~= 0 then
      vim.notify("メモを作成できませんでした: " .. memo_path, vim.log.levels.ERROR)
      return
    end

    -- リンクの追記に失敗してもメモ自体は作れているので、通知だけして開く
    local linked, link_err = append_journal_memo_link(dir .. "/index.org", title)
    if not linked then
      vim.notify(link_err, vim.log.levels.WARN)
    end

    vim.cmd.edit(vim.fn.fnameescape(memo_path))
    vim.cmd("normal! G")
  end)
end

--- 今日の日報ディレクトリのファイルを fzf-lua で選んで開く。
local function open_journal_today()
  local dir = journal_today_dir()
  if vim.fn.isdirectory(dir) == 0 then
    vim.notify("今日の日報ディレクトリはまだありません: " .. dir, vim.log.levels.INFO)
    return
  end
  require("fzf-lua").files({ cwd = dir, prompt = "journal(today)❯ " })
end

--- 日報ディレクトリ（journal/）配下のファイルを、日付をまたいで fzf-lua で選んで開く。
--- 候補は YYYY/MM/DD/<ファイル名> の相対パスで並ぶので、日付でも絞り込める。
--- 新しい日付が先頭に来るよう、ファイル一覧を逆順に並べてから fzf に渡す。
local function open_journal_all()
  if vim.fn.isdirectory(org_journal_dir) == 0 then
    vim.notify("日報ディレクトリはまだありません: " .. org_journal_dir, vim.log.levels.INFO)
    return
  end

  -- fd の出力順はディレクトリの走査順で、日付順にはならない。
  -- パスが YYYY/MM/DD で始まるので、辞書順の逆にすれば新しい日付が先頭に来る。
  -- Debian 系では fd が fdfind という名前で入るため、それも見る。
  local list_cmd
  if vim.fn.executable("fd") == 1 then
    list_cmd = "fd --color=never --type f"
  elseif vim.fn.executable("fdfind") == 1 then
    list_cmd = "fdfind --color=never --type f"
  elseif vim.fn.executable("rg") == 1 then
    list_cmd = "rg --color=never --files"
  else
    vim.notify("fd も rg も見つからないため、日報を検索できません", vim.log.levels.ERROR)
    return
  end

  require("fzf-lua").files({
    cwd = org_journal_dir,
    prompt = "journal❯ ",
    cmd = list_cmd .. " | sort -r",
    -- 絞り込み中もスコアが同じ候補は入力順（＝新しい順）を保つ。
    -- 既定の tiebreak だと、短いパスが先に来て日付の順が崩れる。
    fzf_opts = { ["--tiebreak"] = "index" },
  })
end

-- <Leader>o 配下のうち、org バッファのローカルマップ（oJ など）と被らない文字を選んでいる。
-- m は memo、j は capture とアジェンダの j（日報）に揃えている。
vim.keymap.set("n", "<Leader>om", create_journal_memo, { desc = "日報の markdown メモを作る" })
vim.keymap.set("n", "<Leader>oj", open_journal_today, { desc = "今日の日報ディレクトリを開く" })
-- ノーマルモードの <C-j> は既定では j と同じ動きで、実質空いている。
-- init.vim の <C-j>（skkeleton）は i/c/t モード向けなので衝突しない。
vim.keymap.set("n", "<C-j>", open_journal_all, { desc = "日報ディレクトリ全体を検索して開く" })

-- refile 先の選択を fzf-lua の fuzzy find に差し替える。
-- 既定の実装（OrgCapture:get_destination）は cmdline に「ファイル/見出し」を
-- 補完付きで入力させるため、見出しが増えるほど宛先を選びづらい。クラスの
-- メソッドごと差し替えることで、refile を呼ぶ経路すべて（capture ウィンドウの
-- <Space>or、org ファイルやアジェンダ上の <Space>or）が同じ picker を通る。
--
-- このメソッドは nvim-orgmode 独自の Promise を返し、
-- { file = OrgFile, headline = OrgHeadline? } に解決する契約になっている。
-- headline を省くとファイルのトップレベルが宛先になる。中断時は false を返す。
local OrgCapture = require("orgmode.capture")
local OrgPromise = require("orgmode.utils.promise")

---@return OrgPromise # { file: OrgFile, headline?: OrgHeadline } または false に解決する
function OrgCapture:get_destination()
  -- private メソッドだが、既定の補完と同じ表示（共通の親を落としたファイル名）を
  -- そのまま使いたいので利用する。キーは "inbox.org/" 形式、値は OrgFile。
  local files = self:_get_autocompletion_files()

  -- 分からなかったことリスト（unknowns/）を宛先候補に合流させる。
  --
  -- _get_autocompletion_files() は内部で self.files:all() を回すため、候補は
  -- org_agenda_files にマッチしたファイルに限られる。unknowns/ は「アジェンダに
  -- 載せない」ことを目的にそこから外してあるので、既定のままでは宛先に出てこない。
  -- ファイル間はもちろん、同じファイル内で見出しをぶら下げることもできなくなる。
  --
  -- 一方、refile を実行する Capture:_refile_from_org_file() は宛先に対して
  -- destination_file:update_sync() を呼ぶだけで、org_agenda_files への登録を
  -- 見ていない。読み込み済みの OrgFile でありさえすれば動く。そこで専用の
  -- OrgFiles インスタンスをここで作り、候補にだけ足している。
  -- これでアジェンダの排他性は保ったまま、refile での振り分けだけが通る。
  --
  -- inbox.org からの refile でも unknowns/ が候補に並ぶが、これは意図した挙動。
  -- 「これは調べ物だった」と気づいたタスクをリスト側へ移せる。
  --
  -- load_sync を明示的に呼ぶ必要がある。:all() が経由する ensure_loaded() は
  -- 読み込みを開始せず、load_state が 'loaded' になるまで vim.wait で最大 5 秒
  -- 待つだけの実装で、自前のインスタンスは誰も読み込んでくれない。省くと
  -- <Space>or のたびに 5 秒固まった末に空リストが返る。
  -- force = true にしているのは、毎回 glob を引き直してトピック別ファイルの
  -- 追加を拾うため。
  local OrgFiles = require("orgmode.files")
  local unknowns = OrgFiles:new({ paths = { org_unknowns_dir .. "/**/*.org" }, cache = true })
  unknowns:load_sync(true)
  -- OrgFile.filename は vim.fn.resolve を通った実体のパスなので、接頭辞を落とす
  -- ときも同じ形に揃えておく。将来 diary リポジトリをシンボリックリンクで置いた
  -- 場合でも、接頭辞が一致しなくなって表示が壊れることがない。
  local unknowns_root = vim.fn.resolve(org_unknowns_dir)
  for _, file in ipairs(unknowns:all()) do
    -- 既定の候補は trim_common_root で共通の親を落とした相対パスなので、
    -- 同じ見え方になるよう unknowns/ 起点の相対パスを自分で組む。
    -- 末尾の "/" は、ファイル自身を指すキーの形式（"inbox.org/"）に合わせている。
    local relative = file.filename
    if vim.startswith(relative, unknowns_root .. "/") then
      relative = relative:sub(#unknowns_root + 2)
    else
      -- 想定外のパスでもフルパスを晒さないよう、ファイル名だけに落とす
      relative = vim.fn.fnamemodify(relative, ":t")
    end
    files["unknowns/" .. relative .. "/"] = file
  end

  local names = vim.tbl_keys(files)
  table.sort(names)

  ---@type { display: string, file: OrgFile, headline?: OrgHeadline }[]
  local items = {}
  for _, name in ipairs(names) do
    local file = files[name]
    -- ファイル自身のエントリ。選ぶとトップレベル（受信箱）に入る。
    table.insert(items, { display = name, file = file })
    -- DONE と :ARCHIVE: 付きは、既定の補完と同様に宛先から外れる。
    for _, headline in ipairs(file:get_opened_unfinished_headlines()) do
      local outline_path = headline:get_outline_path()
      local prefix = outline_path ~= "" and (outline_path .. "/") or ""
      table.insert(items, {
        display = name .. prefix .. headline:get_title(),
        file = file,
        headline = headline,
      })
    end
  end

  -- 同名の見出しが複数あっても選択結果を一意に引き当てられるよう、行頭に添字を埋める。
  -- 添字は --with-nth で表示と検索の対象から外す。
  local entries = {}
  for i, item in ipairs(items) do
    entries[i] = string.format("%d\t%s", i, item.display)
  end

  return OrgPromise.new(function(resolve)
    local done = false
    ---@param value { file: OrgFile, headline?: OrgHeadline }|false
    local function finish(value)
      if done then
        return
      end
      done = true
      -- picker を閉じ切ってから refile 本体を走らせる。refile はカレントバッファを
      -- 直接書き換えるため、ウィンドウが元に戻る前に実行されないようにしておく。
      vim.schedule(function()
        resolve(value)
      end)
    end

    require("fzf-lua").fzf_exec(entries, {
      prompt = "Refile❯ ",
      fzf_opts = { ["--delimiter"] = "\t", ["--with-nth"] = "2.." },
      winopts = {
        title = " Refile destination ",
        -- 選択でも中断でもここを通る。fzf-lua はウィンドウを閉じてから action を
        -- 呼ぶので、vim.schedule で 1 tick 遅らせて action の結果を待ち合わせる。
        on_close = function()
          vim.schedule(function()
            finish(false)
          end)
        end,
      },
      actions = {
        ["default"] = function(selected)
          local line = selected and selected[1]
          local index = line and tonumber(line:match("^(%d+)\t"))
          local item = index and items[index]
          if not item then
            return
          end
          finish({ file = item.file, headline = item.headline })
        end,
      },
    })
  end)
end

-- CANCELED にしたときだけ、棄却の理由をその場でメモさせる。
-- org_log_done = "note" にすると DONE のたびに聞かれて煩わしいため、
-- TodoChanged イベントを拾って CANCELED に限定している。
-- 理由は org_log_into_drawer の設定により LOGBOOK ドロワーに畳まれる。
local org_events = require("orgmode.events")
org_events.listen(org_events.event.TodoChanged, function(event)
  -- アジェンダ上で t を押した場合、nvim-orgmode は 1x2 の非表示フロートに対象ファイルを
  -- 開いて書き換える（utils.edit_file）。このときも filetype は "org" になるため、
  -- filetype だけで判定すると、その極小ウィンドウの中でメモ入力を開こうとしてしまう。
  -- nvim-orgmode 自身が立てる b:org_tmp_edit_window を見て、その状況を除外する。
  -- 結果として、理由を聞くのは org ファイルを直接開いて操作したときだけになる。
  if not event.headline or vim.bo.filetype ~= "org" or vim.b.org_tmp_edit_window then
    return
  end
  local todo = event.headline:get_todo()
  if todo == "CANCELED" and event.old_todo_state ~= "CANCELED" then
    require("orgmode").org_mappings:add_note()
  end
end)
