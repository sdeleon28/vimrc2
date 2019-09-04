" Set leader
let mapleader = "\<Space>"

" Use relative numbers by default and always include current line number
set rnu
set nu

" Highlight search matches
set hls

" Enable incremental search
set is

" Put swap and backup files outside project dir to keep it clean
set swapfile
set dir=~/tmp
set backup
set backupdir=~/tmp

function ExploreCurrentFolder()
  exec ":edit " . expand("%:h")
endfunction
nnoremap <LEADER>z :call ExploreCurrentFolder()<CR>

" Use 2 spaces for indentation
set ts=2
set et
set sw=2

" Enable autoindent
set autoindent
set smartindent

" Set Chrome as the default brower
let g:netrw_browsex_viewer='google-chrome'

" Open image
nnoremap <LEADER>i :!open <CFILE><CR><CR>

" Swaps paste mode
set pastetoggle=<F3>
nnoremap <F5> :nohlsearch<CR>

" Mix Vim and system clipboards
set clipboard=unnamed

" Open vertical splits on the right
set splitright

" Set up the dictionary to enable <C-X><C-K> completions
set dictionary=/usr/share/dict/words

nnoremap <LEADER>d :GitGrep -w 'debugger;' -- :/<CR>

nnoremap <LEADER>a :ALEDetail<CR>

" Go to the first error in the current buffer
nnoremap [; :ALEFirst<CR>

" Open file history
nnoremap <LEADER>h :Glog --follow<CR><CR><CR>:copen<CR><Paste>

" Configure smooth scrolling
function SmoothScroll(up)
		set scroll=10
    if a:up
        let scrollaction=""
    else
        let scrollaction=""
    endif
    exec "normal " . scrollaction
    redraw
    let counter=1
    while counter<&scroll
        let counter+=1
        sleep 10m
        redraw
        exec "normal " . scrollaction
    endwhile
endfunction
nnoremap <C-U> :call SmoothScroll(1)<CR>
nnoremap <C-D> :call SmoothScroll(0)<CR>

" Load TODOs in quickfix
nnoremap <F9> :GitGrep -w 'TODO' -- :/ :!/lib '*.js'<CR>

" Android debugging shortcuts
nnoremap <silent> <F9> :!adb shell input keyevent 82 && adb shell input keyevent 19 && adb shell input keyevent 23<CR><CR>
nnoremap <silent> <F10> :!adb shell input keyevent 82<CR><CR>
nnoremap <silent> <F11> :!adb reverse tcp:8081 tcp:8081<CR><CR>

" Follow JavaScript references with proper babel (and module-resolver)
" resolution (requires a git repo in the project's root)
function FollowJsReference()
  " Find the reference and yank it into the r register
  exec "normal ^f'\"ryi'"
  let s:filename = @r
  if s:filename[0] == '.'
    " Treat it as a relative reference
    let s:file_with_js = expand('%:p:h') . s:filename[1:] . ".js"
    let s:file_with_index_js = expand('%:p:h') . s:filename[1:] . "/index.js"
    if filereadable(s:file_with_js)
      exec ":edit " . s:file_with_js
    elseif filereadable(s:file_with_index_js)
      exec ":edit " . s:file_with_index_js
    else
      echo "Couldn't find reference"
    endif
  else
    if g:projectname == 'hive-web'
      let s:out = expand(substitute(s:filename, '\~', '~/js-projects/hive-web/src', ''))
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
    elseif g:projectname == 'sparrow'
      let s:out = expand(substitute(s:filename, '\~', '~/js-projects/sparrow/src', ''))
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
      " If it's not one of my projects, default to using babel
      " Create a file at the root with the code for babel-node to resolve the
      " reference. Ideally, I'd do this with babel-node's eval, but it errors out.
      " Instead, I create a script, evaluate it then delete it.
      let s:script_content = 'console.log(require.resolve("' . @r . '"));'
      let s:root_dir = systemlist('dirname $(. ~/vim/vimrc/scripts/find-ancestor.sh .babelrc)')[0]
      let s:create_command = 'tee ' . s:root_dir . '/___resolve.js'
      call system(s:create_command, s:script_content)
      " Run babel-node from the root dir
      let s:babel_command = 'cd  ' . s:root_dir . '&& NODE_ENV=development babel ./___resolve.js | node'
      let s:out = system(s:babel_command)
      exec ":edit " . s:out
      " Clean up
      let s:delete_command = 'rm ' . s:root_dir . '/___resolve.js'
      call system(s:delete_command)
    endif
  endif
endfunction
nnoremap <LEADER>gj :call FollowJsReference()<CR>

" fbsimctl helper mappings
nnoremap <LEADER>ilb :r!fbsimctl list \| grep Booted<CR>ggdd
nnoremap <LEADER>ils :r!fbsimctl list \| grep Shutdown<CR>ggdd
nnoremap <LEADER>ill :r!fbsimctl list<CR>ggdd
nnoremap <LEADER>ib ^"fyiW:!fbsimctl <C-r>f boot<CR>
nnoremap <LEADER>is ^"fyiW:!fbsimctl <C-r>f shutdown<CR>
nnoremap <LEADER>if :!rm ~/Library/Preferences/com.apple.iphonesimulator.plist<CR>

" Faster searching
function FindSymbolInProject()
  exec 'normal "ryiw'
  exec "GitGrep -w '" . @r . "' -- :/"
endfunction
function FindSymbolUsageInProject()
  exec 'normal "ryiw'
  exec "GitGrep -w '" . @r . "' -- :/"
  exec 'normal yae'
  new
  exec 'normal pggddm<Gm>'
  silent exec "'<,'>!grep -v import | grep -v export | grep -v spec"
  cgetbuffer
  exec 'q!'
  exec 'normal [Q'
endfunction
function FindComponentUsageInProject()
  exec 'normal "ryiw'
  exec "GitGrep -w '<" . @r . "' -- :/"
endfunction
function FindDefinitionInProject()
  exec 'normal "ryiw'
  exec "GitGrep -w -e 'class " . @r . "' -e 'const " . @r . "' -e 'function " . @r . "' -- :/"
endfunction
function FindReducerInProject()
  exec 'normal mB'
  exec 'normal "ryiw'
  exec "GitGrep -w -e '" . @r . " = createAction' -- :/"
  cclose
  exec 'normal t)"ryiw'
  exec "GitGrep -w '" . @r . "\\]' -- :/"
  exec 'normal '
endfunction
function FindSagaInProject()
  call FindDefinitionInProject()
  cclose
  exec 'normal f("ryi('
  exec "GitGrep -w 'takeLatest\\(" . @r . "' -- :/"
  cclose
  exec 'normal f(;wgd'
endfunction
function FindTest()
  let s:test_filename = expand("%:h") . '/__tests__/' . expand("%:t:r") . '.spec.js'
  exec ':vs ' . s:test_filename
endfunction
nnoremap <LEADER>fs :call FindSymbolInProject()<CR>
nnoremap <LEADER>fa :call FindSymbolUsageInProject()<CR>
nnoremap <LEADER>fu :call FindComponentUsageInProject()<CR><CR>:cclose<CR>
nnoremap <LEADER>fd :call FindDefinitionInProject()<CR><CR>:cclose<CR>
nnoremap <LEADER>fr :call FindReducerInProject()<CR>
nnoremap <LEADER>fg :call FindSagaInProject()<CR>
nnoremap <LEADER>ft :call FindTest()<CR>
function RefactorImplicitReturnFunction()
  exec 'normal myysa){`yarr gggqG'
endfunction
nnoremap <LEADER>fn :call RefactorImplicitReturnFunction()<CR><CR>
nnoremap <F8> gg/class<CR>w
nnoremap <LEADER>tp gg/type Props<CR>w
nnoremap <LEADER>ts gg/type State<CR>w
nnoremap <LEADER>mr gg/render(<CR>w
nnoremap <F1> :GitGrep 
nnoremap <F2> :GitGrep -w 
