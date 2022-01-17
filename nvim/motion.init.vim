" hop.nvim
nnoremap <C-l> <cmd>HopWordAC<CR>
nnoremap <C-h> <cmd>HopWordBC<CR>
nnoremap <C-j> <cmd>HopLineAC<CR>
nnoremap <C-k> <cmd>HopLineBC<CR>
" Use better keys for the bépo keyboard layout and set
" a balanced distribution of terminal / sequence keys
lua require'hop'.setup { keys = 'etovxqpdygfblzhckisuran', jump_on_sole_occurrence = false }

nmap ' <cmd>Pounce<CR>
vmap ' <cmd>Pounce<CR>
omap g' <cmd>Pounce<CR>
