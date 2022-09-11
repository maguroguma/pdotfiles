"""
" PLUGSETTING: cohama/lexima.vim
"""
" yuki-yanoさんのスクリプトを参考に
" https://github.com/yuki-yano/dotfiles/blob/1c865f70c5ca3c2b4b59181c30bdb69ac6a0870a/.vimrc
" '\%#' はカーソル位置を表す
function! SetupLexima() abort
  call <SID>setup_lexima_insert()
endfunction

function! s:setup_lexima_insert() abort
  let s:rules = []

  "" markdown
  let s:rules += [
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\%#',                        'input': '<C-w><CR>',                         },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><CR>',                    },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s*-\s\w.*\%#',                 'input': '<CR>-<Space>',                      },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\[\%#\]',                    'input': '<End><C-w><C-w><C-w><CR>',          },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\[\%#\]',                'input': '<End><C-w><C-w><C-w><C-w><CR>',     },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><CR>',               },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><CR>',          },
  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<CR>-<Space>[]<Space><Left><Left>', },
  \ ]
  "" markdown(original)
  let s:rules += [
  \ { 'filetype': 'markdown', 'char': '<Space>', 'at': '\[\%#', 'input': '<Space>'},
  \ ]

  for s:rule in s:rules
    call lexima#add_rule(s:rule)
  endfor
endfunction

call SetupLexima()
