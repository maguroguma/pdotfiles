"""
" PLUGSETTING: tamago324/lir.nvim
"""

lua << EOF
local actions = require'lir.actions'
local mark_actions = require 'lir.mark.actions'
local clipboard_actions = require'lir.clipboard.actions'

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require'lir'.setup {
  show_hidden_files = true,
  devicons_enable = true,
  mappings = {
    ['l']     = actions.edit,
    ['<C-s>'] = actions.split,
    ['<C-v>'] = actions.vsplit,
    ['<C-t>'] = actions.tabedit,

    ['h']     = actions.up,
    ['q']     = actions.quit,

    ['M']     = actions.mkdir,
    -- ['N']     = actions.newfile,
    ['N']     = actions.touch,
    ['r']     = actions.rename,
    ['@']     = actions.cd,
    ['Y']     = actions.yank_path,
    ['.']     = actions.toggle_show_hidden,
    ['d']     = actions.delete,

    ['x'] = function()
      mark_actions.toggle_mark()
      vim.cmd('normal! j')
    end,
    ['c'] = clipboard_actions.copy,
    ['m'] = clipboard_actions.cut,
    ['p'] = clipboard_actions.paste,
  },
  float = {
    winblend = 0,
    curdir_window = {
      enable = false,
      highlight_dirname = false
    },

    -- -- You can define a function that returns a table to be passed as the third
    -- -- argument of nvim_open_win().
    win_opts = function()
      local width = math.floor(vim.o.columns * 0.5)
      local height = math.floor(vim.o.lines * 0.8)
      return {
        border = {
          "+", "=", "+", "│", "+", "=", "+", "│",
        },
        width = width,
        height = height,
      }
    end,
  },
  hide_cursor = true,
  on_init = function()
    -- use visual mode
    vim.api.nvim_buf_set_keymap(
      0,
      "x",
      "J",
      ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
      { noremap = true, silent = true }
    )

    -- echo cwd
    vim.api.nvim_echo({ { vim.fn.expand("%:p"), "Normal" } }, false, {})
  end,
}

-- custom folder icon
require'nvim-web-devicons'.set_icon({
  lir_folder_icon = {
    icon = "",
    color = "#7ebae4",
    name = "LirFolderNode"
  }
})

require'lir.git_status'.setup({
  show_ignored = false
})
EOF

" nnoremap <C-f> :<C-u>edit .<CR>
nnoremap <C-f> :<C-u>lua require'lir.float'.toggle()<CR>
nnoremap <C-h> :<C-u>lua require'lir.float'.toggle('.')<CR>
" nnoremap <C-f>  :<C-u>lua require'lir.float'.init()<CR>
command! Lir :edit .
