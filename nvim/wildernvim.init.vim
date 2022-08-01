call wilder#enable_cmdline_enter()
set wildcharm=<Tab>
cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"

" only / and ? are enabled by default
call wilder#set_option('modes', ['/', '?', ':'])

" use wilder#wildmenu_lightline_theme() if using Lightline
" 'highlights' : can be overriden, see :h wilder#wildmenu_renderer()
call wilder#set_option('renderer', wilder#wildmenu_renderer(
      \ wilder#wildmenu_airline_theme({
      \   'highlights': {},
      \   'highlighter': wilder#basic_highlighter(),
      \   'separator': ' · ',
      \ })))

" popup mode (experimental)
" 'highlighter' : applies highlighting to the candidates
" call wilder#set_option('renderer', wilder#popupmenu_renderer({
"       \ 'highlighter': wilder#basic_highlighter(),
"       \ }))

" call wilder#set_option('renderer', wilder#renderer_mux({
"       \ ':': wilder#popupmenu_renderer({
"       \ 'highlighter': wilder#basic_highlighter(),
"       \ }),
"       \ '/': wilder#wildmenu_renderer(
"       \ wilder#wildmenu_airline_theme({
"       \   'highlights': {},
"       \   'highlighter': wilder#basic_highlighter(),
"       \   'separator': ' · ',
"       \ })),
"       \ }))

call wilder#set_option('renderer', wilder#renderer_mux({
      \ ':': wilder#popupmenu_renderer({
      \ 'highlighter': wilder#basic_highlighter(),
      \ }),
      \ }))
