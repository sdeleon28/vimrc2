function FollowJsReference()
  " Find the reference and yank it into the r register
  exec "normal ^f'\"ryi'"
  let s:filename = @r
  let s:current_dir = getcwd()
  if s:filename[0] == '.'
    " Treat it as a relative reference
    let s:file_with_js = expand('%:p:h') . '/' . s:filename . ".js"
    let s:file_with_index_js = expand('%:p:h') . '/' . s:filename . "/index.js"
    if filereadable(s:file_with_js)
      exec ":edit " . s:file_with_js
    elseif filereadable(s:file_with_index_js)
      exec ":edit " . s:file_with_index_js
    else
      echo "Couldn't find reference"
    endif
  elseif s:filename[0] == '~'
    let s:out = expand(substitute(s:filename, '\~', s:current_dir . '/src', ''))
    let s:file_with_js = s:out . ".js"
    let s:file_with_index_js = s:out . "/index.js"
    if filereadable(s:file_with_js)
      exec ":edit " . s:file_with_js
    elseif filereadable(s:file_with_index_js)
      exec ":edit " . s:file_with_index_js
    else
      echom s:file_with_js
      echom s:file_with_index_js
      echo "Couldn't find reference"
    endif
  else
    " Assume external library
    let s:command = 'node -e ''console.log(require.resolve("' . s:filename . '"));'''
    let s:out = system(s:command)
    exec ":edit " . s:out
  endif
endfunction
nnoremap <LEADER>gj :call FollowJsReference()<CR>

function GoToDefinition()
  " Grab the token, go to definition, find the next single quote
  exec 'normal "tyiwgd/''^'
  " Open the reference in the line of the single quote
  call FollowJsReference()
  " Once inside the target file, find the token and center the screen around
  " it
  exec 'normal /' . @t . 'zz'
endfunction
nnoremap <F5> :call GoToDefinition()<CR>

augroup go_to_definition
  autocmd!
  autocmd FileType javascript nnoremap <LEADER><LEADER> :call GoToDefinition()<CR>
augroup END
