"""
" PLUGSETTING: rlane/pounce.nvim
" PLUGSETTING: yuki-yano/fuzzy-motion.vim
"""
nmap ' :<C-u>FuzzyMotion<CR>
" nmap ' <cmd>Pounce<CR>
vmap ' <cmd>Pounce<CR>
omap g' <cmd>Pounce<CR>
let g:fuzzy_motion_labels = ['H', 'J', 'K', 'L', 'Y', 'U', 'I', 'O', 'P', 'N', 'M', 'Q', 'W', 'E', 'R', 'T', 'A', 'S', 'D', 'F', 'G', 'Z', 'X', 'C', 'V', 'B']
lua << EOF
require'pounce'.setup{
  accept_keys = "HJKLYUIOPNMQWERTASDFGZXCVB",
  accept_best_key = "<enter>",
  multi_window = true,
  debug = false,
}
EOF
