" Set leader
let mapleader = "\<Space>"

" Simple word refactoring shortcut. Hit <Leader>r<new word> on a word to
" refactor it. Navigate to more matches with `n` and `N` and redo refactoring
" by hitting the dot key.
map <Leader>r *Nciw

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

"nnoremap <LEADER>c :edit %:h/component.js<CR>

map <C-A> :py3f ~/lib/clang/share/clang/clang-format.py<cr>
imap <C-A> <c-o>:py3f ~/lib/clang/share/clang/clang-format.py<cr>

function OpenHeaderFile()
  exec ":edit " . expand("%:r") . '.h'
endfunction
nnoremap <LEADER>h :call OpenHeaderFile()<CR>

function OpenCppFile()
  exec ":edit " . expand("%:r") . '.cpp'
endfunction
nnoremap <LEADER>c :call OpenCppFile()<CR>


" Use 4 spaces for indentation
set ts=4
set et
set sw=4

" Enable autoindent
set autoindent
set smartindent

" Set Chrome as the default brower
let g:netrw_browsex_viewer='google-chrome'

" Open image
nnoremap <LEADER>i :!open <CFILE><CR><CR>

" Swaps paste mode
set pastetoggle=<F3>

" Stop highlighting search
nnoremap <LEADER>l :nohlsearch<CR>

" Print current filename
nnoremap <LEADER>n :echo expand('%')<CR>

" Go to adjacent component
"nnoremap <LEADER>c :edit %:h/component.js<CR>

" Save javascript reference to clipboard
nnoremap <LEADER>% :silent !echo % \| sed 's/\/index\.js$//g' \| sed 's/\.js$//g' \| tail -1 \| pbcopy<CR>

" Mix Vim and system clipboards
set clipboard=unnamed

" Open vertical splits on the right
set splitright

" Set up the dictionary to enable <C-X><C-K> completions
set dictionary=/usr/share/dict/words

nnoremap <LEADER>d :GitGrep -w 'debugger;' -- :/<CR>

nnoremap <LEADER>a :ALEDetail<CR>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Go to the first error in the current buffer
nnoremap [; :ALEFirst<CR>

" Open file history
"nnoremap <LEADER>h :Glog --follow<CR><CR><CR>:copen<CR><Paste>

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

" javascript tricks
augroup filetype_javascript
  autocmd!
  autocmd FileType javascript,javascript.jsx iabbrev rr return
  autocmd FileType javascript,javascript.jsx iabbrev ff function
  autocmd FileType javascript,javascript.jsx iabbrev cc const
  autocmd FileType javascript,javascript.jsx iabbrev xx export
  autocmd FileType javascript,javascript.jsx iabbrev xc export const
  autocmd FileType javascript,javascript.jsx iabbrev xd export default
  autocmd FileType javascript,javascript.jsx iabbrev ii import from '';<left><left><left><left><left><left><left><left><left>
  autocmd FileType javascript,javascript.jsx iabbrev ni import { } from '';<left><left><left><left><left><left><left><left><left><left><left>
  autocmd FileType javascript,javascript.jsx,json nnoremap <Leader>p :ALEFix<CR>
augroup END

inoremap {,<CR> {},<Esc>hi<CR><Esc>O
inoremap {;<CR> {};<Esc>hi<CR><Esc>O
inoremap {<CR> {}<Esc>i<CR><Esc>O
inoremap [,<CR> [],<Esc>hi<CR><Esc>O
inoremap [;<CR> [];<Esc>hi<CR><Esc>O
inoremap [<CR> []<Esc>i<CR><Esc>O
inoremap (,<CR> (),<Esc>hi<CR><Esc>O
inoremap (;<CR> ();<Esc>hi<CR><Esc>O
inoremap (<CR> ()<Esc>i<CR><Esc>O

nnoremap <LEADER>gh yiW:!open https://github.com/search?q=react-native-permissions/<c-r>*<CR><CR>

" Run test for current file
nnoremap <LEADER>rt :!tmux respawn-window -t :test -k && tmux send-keys -t :test "TZ='Europe/London' yarn test %" Enter && tmux select-window -t :test<CR><CR>
nnoremap <LEADER>dt :!tmux respawn-window -t :test -k && tmux send-keys -t :test "dtest %" Enter && tmux select-window -t :test<CR><CR>

" Insert timestamp
nnoremap <LEADER>ts :r!date +\%Y-\%m-\%dT\%H:\%M:\%S.000Z<CR>
