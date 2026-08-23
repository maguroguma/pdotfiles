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
  messages = {
    enabled = false,
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
vim.keymap.set("i", "<C-a>gr", function()
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
<Space>or   -> refile
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

  for _, item in ipairs(data.items) do
    if item.icon then
      -- セパレータは既定で length = 80 と長いので、幅はこちらで決め直す
      separators[#lines + 1] = item.icon
      table.insert(lines, "")
    else
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

require("orgmode").setup {
  -- diary リポジトリの中の org/ だけを org-mode の領域として隔離する。
  -- 直下の *.org のみを対象にするため、archive/ 配下は走査されず、
  -- アジェンダには現役のタスクだけが並ぶ。
  org_agenda_files = { org_dir .. "/*.org" },
  -- capture の投入先は todo.org に統一し、その「直下（トップレベル）」を受信箱として使う。
  -- 親にぶら下げたくなったら <Space>or で同じファイルの中を移動させればよく、
  -- 受信箱専用のファイルを別に持つ必要がない。
  -- この設定自体は、target を書いていない capture テンプレートの既定の宛先。
  -- 下の org_capture_templates は全て target を明示しているので、実際には
  -- :checkhealth orgmode の警告を消すための保険として効いている。
  org_default_notes_file = org_dir .. "/todo.org",

  -- タスクの「状態」でワークフローを表現する。運用ルールは以下のとおり。
  --   SOMEDAY … やるかどうかまだ決めていない。週次レビューで棚卸しする
  --   TODO    … やると決めたが、着手できる粒度に分解できていない（＝分解待ち）
  --   NEXT    … 分解済みで、いま着手できる「次の一手」
  --   DOING   … 着手中（taskpaper の @inProgress）
  --   WAIT    … 他者・外部要因の待ちでブロックされている（taskpaper の @wait）
  --   DONE    … 完了
  --   CANCELED… 棄却。「終わった」扱いにして DONE と区別する
  -- 「手をつけられる粒度になったら即 NEXT にする」を守ることで、TODO のまま残って
  -- いるものが「分解待ちの大きなタスク」として自動的に炙り出される。
  org_todo_keywords = {
    "SOMEDAY(s)",
    "TODO(t)",
    "NEXT(n)",
    "DOING(g)",
    "WAIT(w)",
    "|",
    "DONE(d)",
    "CANCELED(c)",
  },
  org_todo_keyword_faces = {
    SOMEDAY = ":foreground #928374 :slant italic",
    NEXT = ":foreground #b57614 :weight bold",  -- 次の一手が一番目立つようにする
    DOING = ":foreground #79740e :weight bold", -- 旧 @inProgress の色
    WAIT = ":foreground #076678 :weight bold",  -- 旧 @wait の色
    CANCELED = ":foreground #928374 :slant italic",
  },

  -- @done(YYYY-MM-DD) 相当。DONE / CANCELED にした日時を CLOSED: として自動で残す
  org_log_done = "time",
  org_log_into_drawer = "LOGBOOK",

  -- 自作していた due ハイライト（critical_days / warning_days）の代替。
  -- この日数以内の DEADLINE がアジェンダ上で警告扱いになる。
  org_deadline_warning_days = 7,

  -- taskpaper の Archive: セクション相当。
  -- todo.org -> org/archive/todo.org_archive に退避する（相対パス指定）
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
      target = org_dir .. "/todo.org",
    },
    d = {
      description = "Todo（期限付き。カレンダーで日付を選ぶ）",
      -- %^{...}t はカレンダーを開いて日付を選ばせる
      template = "* TODO %?\nDEADLINE: %^{期限}t\n:PROPERTIES:\n:CREATED: %U\n:END:",
      target = org_dir .. "/todo.org",
    },
    s = {
      description = "Someday（やるかどうか未定のアイデア）",
      template = "* SOMEDAY %?\n:PROPERTIES:\n:CREATED: %U\n:END:",
      target = org_dir .. "/todo.org",
    },
    n = {
      -- 既存タスクのサブタスクを作るとき用。capture ウィンドウで <Space>or を押すと
      -- 「todo.org/親タスク名」を補完で選べて、そのまま子見出しとしてぶら下がる。
      description = "Next（サブタスク。<Space>or で親へぶら下げる）",
      template = "* NEXT %?\n:PROPERTIES:\n:CREATED: %U\n:END:",
      target = org_dir .. "/todo.org",
    },
    p = {
      -- 分解待ちの「塊」を入れる口。ここだけ TODO キーワードを付けずに投入する。
      -- notes.org ではなく todo.org に入れるのは、notes.org を「タスクではないもの」の
      -- 置き場として保ち、週次レビューで読む対象を todo.org だけに閉じておくため。
      -- 期限はプロジェクト自体には持たせない。agenda ビューは TODO キーワードではなく
      -- 日付で拾うため、ここに DEADLINE を書くと d / w の日付ブロックに出続けてしまう。
      -- 期限は分解後の NEXT 側に付ける。
      description = "Project（分解待ちの塊。状態は持たせない）",
      template = "* %? :project:\n:PROPERTIES:\n:CREATED: %U\n:END:",
      target = org_dir .. "/todo.org",
    },
    m = {
      description = "Memo（notes.org へ。タスクではないもの）",
      template = "* %?\n%U",
      target = org_dir .. "/notes.org",
    },
  },

  org_agenda_custom_commands = {
    -- 日次: いま手を動かせるものだけに絞る。TODO / SOMEDAY はあえて出さない。
    d = {
      description = "日次ダッシュボード",
      types = {
        { type = "agenda", org_agenda_span = "day", org_agenda_overriding_header = "今日（期限・予定）" },
        { type = "tags_todo", match = "/DOING", org_agenda_overriding_header = "着手中" },
        { type = "tags_todo", match = "/NEXT", org_agenda_overriding_header = "次の一手" },
        { type = "tags_todo", match = "/WAIT", org_agenda_overriding_header = "待機中（ブロック中）" },
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
    agenda = { org_agenda_archive = "<prefix>z" },
  },

  -- 選択メニューだけを中央のフロートに差し替える。
  -- ハンドラを設定すると cit（TODO fast access）もこちらを通る。
  ui = {
    menu = { handler = org_menu_popup },
  },
}

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
