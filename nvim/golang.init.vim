" vim-go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
" LSPに任せる機能をOFFにする
let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0

" vim-go tutorial

" https://github.com/hnakamur/vim-go-tutorial-ja

" :GoInstallBinaries
" :GoUpdateBinaries

" :GoTestFunc
" カーソルの下にある関数だけをテストする（マッピングすると良さそう）
" :GoTestCompile
" テストファイルをコンパイルするが実行はしない
" :GoCoverage
" `go test -coverprofile tempfile` が実行される
" :GoCoverageClear
" ハイライトを解除する
" :GoCoverageToggle
" ハイライトをトグルする
" :GoCoverageBrowser
" `go tool cover` を実行してHTMLページを作成しデフォルトブラウザで開く

" autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

" :GoFmt
" gofmtを実行する
" 以下はgofmtしない設定
" let g:go_fmt_autosave = 0
" :GoImport xxx
" importパスに追加する、補完も効く
" :GoImportAs str strings
" :GoImports
" 明示的に `goimports` する

" ハイライト
" :help go-settings
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

" :GoLint
" `golint` を実行する
" :GoVet
" `go vet` を実行する
" :GoMetaLinter
" `go vet, golint, errcheck` を同時に実行する
" 以下はデフォルトなので不要
" let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_autosave = 0
" オートで実行するものは選定できる
" let g:go_metalinter_autosave_enabled = ['vet', 'golint']
