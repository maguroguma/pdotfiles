" %:hのための、:hのマッピング
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
