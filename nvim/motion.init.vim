" hop.nvim
nnoremap <C-l> <cmd>HopWordAC<CR>
nnoremap <C-h> <cmd>HopWordBC<CR>
nnoremap <C-j> <cmd>HopLineAC<CR>
nnoremap <C-k> <cmd>HopLineBC<CR>
" nnoremap ' <cmd>HopChar2<CR>
xnoremap <C-l> <cmd>HopWordAC<CR>
xnoremap <C-h> <cmd>HopWordBC<CR>
xnoremap <C-j> <cmd>HopLineAC<CR>
xnoremap <C-k> <cmd>HopLineBC<CR>
" xnoremap ' <cmd>HopChar2<CR>
" Use better keys for the bépo keyboard layout and set
" a balanced distribution of terminal / sequence keys
lua require'hop'.setup { keys = 'etovxqpdygfblzhckisuran', jump_on_sole_occurrence = false }

nmap ; :<C-u>FuzzyMotion<CR>
" nmap ' <cmd>Pounce<CR>
vmap ; <cmd>Pounce<CR>
omap g; <cmd>Pounce<CR>
let g:fuzzy_motion_labels = ['H', 'J', 'K', 'L', 'Y', 'U', 'I', 'O', 'P', 'N', 'M', 'Q', 'W', 'E', 'R', 'T', 'A', 'S', 'D', 'F', 'G', 'Z', 'X', 'C', 'V', 'B']
lua << EOF
require'pounce'.setup{
  accept_keys = "HJKLYUIOPNMQWERTASDFGZXCVB",
  accept_best_key = "<enter>",
  multi_window = true,
  debug = false,
}
EOF
