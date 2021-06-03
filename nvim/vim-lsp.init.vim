" https://github.com/thomasfaingnaert/vim-lsp-neosnippet

if executable('gopls')
    augroup vim_lsp_go
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'gopls',
                    \ 'cmd': {server_info->['gopls']},
                    \ 'whitelist': ['go'],
                    \ })
        autocmd FileType go setlocal omnifunc=lsp#complete
    augroup end
endif

set completeopt+=menuone
