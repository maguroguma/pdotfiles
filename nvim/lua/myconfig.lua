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
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    theme = 'gruvbox_light',

    disabled_filetypes = {
      statusline = { "Avante", "AvanteInput", "AvanteSelectedFiles" },
      winbar = { "Avante", "AvanteInput", "AvanteSelectedFiles" },
    },
  },
  sections = {
    lualine_a = {
      {
        "macro-recording",
        fmt = show_macro_recording,
      },
      'mode',
    },
    lualine_b = {'location'},
    lualine_c = {
      {
        'filename',
        path = 1,
        shorting_target = 40,
        newfile_status = true,   -- Display new file status (new file means no write after created)
        symbols = {
          modified = '[+]',      -- Text to show when the file is modified.
          readonly = '[-RO]',      -- Text to show when the file is non-modifiable or readonly.
          unnamed = '[No Name]', -- Text to show for unnamed buffers.
          newfile = '[New]',     -- Text to show for new created file before first writting
        },
      },
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'branch'},
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
    lualine_x = {'location'},
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

-- PLUGSETTING: SmoothCursor.nvim
require('smoothcursor').setup()
local autocmd = vim.api.nvim_create_autocmd

autocmd({ 'ModeChanged' }, {
  callback = function()
    local current_mode = vim.fn.mode()
    if current_mode == 'n' then
      vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = 'CadetBlue4' })
      vim.fn.sign_define('smoothcursor', { text = '●' })
    elseif current_mode == 'v' then
      vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = 'CadetBlue4' })
      vim.fn.sign_define('smoothcursor', { text = '' })
    elseif current_mode == 'V' then
      vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = 'CadetBlue4' })
      vim.fn.sign_define('smoothcursor', { text = '' })
    elseif current_mode == '�' then
      vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = 'CadetBlue4' })
      vim.fn.sign_define('smoothcursor', { text = '' })
    elseif current_mode == 'i' then
      vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = 'CadetBlue4' })
      vim.fn.sign_define('smoothcursor', { text = '' })
    end
  end,
})

-- PLUGSETTING: lewis6991/gitsigns.nvim
require('gitsigns').setup {
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },

  on_attach = function(bufnr)
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

vim.keymap.set("n", "gn", "<cmd>Gitsigns next_hunk<CR>")
vim.keymap.set("n", "gN", "<cmd>Gitsigns prev_hunk<CR>")
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

-- PLUGSETTING: nvim-hlslens
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

-- PLUGSETTING: nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
  parser_install_dir = vim.fn.expand("$XDG_DATA_HOME/nvim/site/pack/jetpack/nvim-treesitter"),
}

-- PLUGSETTING: nvim-neo-tree/neo-tree.nvim
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
      enabled = false, -- This will find and focus the file in the active buffer every time
      --               -- the current file is changed while the tree is open.
      leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
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
    follow_current_file = {
      enabled = true, -- This will find and focus the file in the active buffer every time
      --              -- the current file is changed while the tree is open.
      leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
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

-- PLUGSETTING: nvim-cmp
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

cmp.setup({
  sources = {
    { name = 'claude_slash', priority = 900 },
    { name = 'claude_at', priority = 900 },
  },

  -- enabled = function()
  --   -- cocが有効な場合はnvim-cmpを無効化
  --   if vim.g.coc_enabled then
  --     return false
  --   end
  --   return true
  -- end

  view = {
    entries = {
      name = 'native',  -- ネイティブビューを使用
    }
  }
})

-- PLUGSETTING: pounce
require'pounce'.setup{
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
vim.keymap.set("n", "F", "<cmd>AerialToggle!<CR>")

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
  filetype_ignore = {},  -- Filetype to ignore when running deletions
  file_glob_ignore = {},  -- File name glob pattern to ignore when running deletions (e.g. '*.md')
  file_regex_ignore = {}, -- File name regex pattern to ignore when running deletions (e.g. '.*[.]md')
  preserve_window_layout = { 'this', 'nameless' },  -- Types of deletion that should preserve the window layout
  next_buffer_cmd = nil,  -- Custom function to retrieve the next buffer when preserving window layout
})

vim.keymap.set('n', '<Space>d', "<cmd>BDelete hidden<cr>", { noremap = true, silent = false })
vim.keymap.set('n', '<Space>D', "<cmd>BWipeout all<cr>", { noremap = true, silent = false })

-- PLUGSETTING: Wansmer/treesj
require('treesj').setup({
  use_default_keymaps = false,
})

-- PLUGSETTING: folke/noice.nvim
-- require('noice').setup({
--   cmdline = {
--     -- view = "cmdline_popup",
--     view = "cmdline",
--     opts = {
--       position = { row = '40%', col = '50%' },
--     },
--   },
--   messages = {
--     enabled = false,
--   },
--   lsp = {
--     override = {
--       ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
--       ["vim.lsp.util.stylize_markdown"] = true,
--       ["cmp.entry.get_documentation"] = true,
--     },
--   },
-- })

-- PLUGSETTING: delphinus/skkeleton_indicator.nvim
require("skkeleton_indicator").setup {}

-- PLUGSETTING: nacro90/numb.nvim
require('numb').setup()

-- PLUGSETTING: atusy/treemonkey.nvim
vim.keymap.set({"x", "o"}, "m", function()
  require("treemonkey").select({
    ignore_injections = false,
    highlight = { backdrop = "Comment" }
  })
end)

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
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
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
    height           = 0.6,            -- window height
    width            = 0.8,            -- window width
    row              = 0.5,            -- window row position (0=top, 1=bottom)
    col              = 0.5,            -- window col position (0=left, 1=right)

    preview = {
      default = false,
      vertical       = "down:50%",      -- up|down:size
      layout         = "vertical",          -- horizontal|vertical|flex
    },
  },
  git = {
    status = {
      prompt        = 'GitStatus❯ ',
      actions = {
        ["right"]  = false,
        ["left"]   = false,
        ["ctrl-l"]  = { fn = actions.git_unstage, reload = true },
        ["ctrl-h"]   = { fn = actions.git_stage, reload = true },
        ["ctrl-x"] = { fn = actions.git_reset, reload = true },
      },
    },
  },
  buffers = {
    prompt            = 'Buffers❯ ',
  },
})
-- light theme だとまぶしかったので暗くした MediumSpringGreen -> CadetBlue4
vim.api.nvim_set_hl(0, "FzfLuaHeaderBind", { fg = "CadetBlue4" })
vim.api.nvim_set_hl(0, "FzfLuaPathLineNr", { fg = "CadetBlue4" })
vim.api.nvim_set_hl(0, "FzfLuaTabMarker", { fg = "CadetBlue4" })

-- PLUGSETTING: uga-rosa/ccc.nvim
require("ccc").setup()

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

-- use Neovim nightly branch
require('ufo').setup()
