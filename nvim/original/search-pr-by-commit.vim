function! s:buildGitHubPRSearchURL(...)
  " GitHub PR search link
  let l:shell_one_liner = 'git remote -v | '
        \ . 'grep "github" | '
        \ . 'cut -d":" -f2 | '
        \ . 'cut -d"." -f1 | '
        \ . 'sort | uniq | '
        \ . 'awk ''{ printf "https://github.com/%s/pulls?q=is:pr is:closed ", $1 }'''
  let l:command_result = system(l:shell_one_liner)

  " word on the cursor
  let l:temp = @z
  norm "zyiw
  let l:search_word = @z
  let @z = l:temp

  " build query URL and assign it to the default and clipboard registers
  let l:goal = l:command_result . l:search_word
  let @" = l:goal
  let @+ = l:goal

  " interactive question whether open it by your default browser
  let l:confirm_msg = 'Open it by browser? -> ' . '"' . l:goal . '"'
  let l:is_open_browser = confirm(l:confirm_msg, "y yes\nn no")
  if l:is_open_browser != 1
    return
  endif
  if executable('open')
    let l:open_command = 'open ' . "'" . l:goal . "'"
    call system(l:open_command)
  elseif executable('xdg-open')
    let l:open_command = 'xdg-open ' . "'" . l:goal . "'"
    call system(l:open_command)
  else
    echo 'failed to open'
  endif
endfunction

command! -nargs=? GitHubPRSearchURL :call s:buildGitHubPRSearchURL(<f-args>)
