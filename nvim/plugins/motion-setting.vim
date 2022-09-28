"""
" PLUGSETTING: rlane/pounce.nvim
" PLUGSETTING: yuki-yano/fuzzy-motion.vim
"""
" nmap ' :<C-u>FuzzyMotion<CR>
nmap ' <cmd>Pounce<CR>
vmap ' <cmd>Pounce<CR>
omap g' <cmd>Pounce<CR>

let g:fuzzy_motion_labels = [
      \ 'H', 'J', 'K', 'L', 'Y',
      \ 'U', 'I', 'O', 'P', 'N',
      \ 'M', 'Q', 'W', 'E', 'R',
      \ 'T', 'A', 'S', 'D', 'F',
      \ 'G', 'Z', 'X', 'C', 'V',
      \ 'B'
      \]
highlight FuzzyMotionMatch ctermbg=240 ctermfg=DarkGreen

highlight PounceMatch      cterm=underline,bold ctermfg=49 ctermbg=236 gui=underline,bold guifg=#555555 guibg=#FFAF60
highlight PounceGap        cterm=underline,bold ctermfg=214 ctermbg=236 gui=underline,bold guifg=#555555 guibg=#E27878
highlight PounceAccept     cterm=underline,bold ctermfg=184 ctermbg=236 gui=underline,bold guifg=#FFAF60 guibg=#555555
highlight PounceAcceptBest cterm=underline,bold ctermfg=196 ctermbg=236 gui=underline,bold guifg=#EE2513 guibg=#555555

lua << EOF
require'pounce'.setup{
  accept_keys = "HJKLYUIOPNMQWERTASDFGZXCVB",
  accept_best_key = "<enter>",
  multi_window = true,
  debug = false,
}
EOF
