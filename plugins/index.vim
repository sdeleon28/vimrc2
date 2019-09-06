" Shows git status in each line
Plug 'airblade/vim-gitgutter'

" CtrlP
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_user_command = [
    \ '.git', 'cd %s && git ls-files . -co --exclude-standard | egrep -v "^lib/"',
    \ 'find %s -type f'
    \ ]
let g:ctrlp_max_files=0
let g:ctrlp_max_depth=40

" CtrlP on steroids
Plug 'tacahiroy/ctrlp-funky'
nnoremap <C-F> :CtrlPFunky<CR>
nnoremap <C-]> :CtrlPBuffer<CR>
" narrow the list down with a word under cursor
" nnoremap <LEADER>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>

Plug 'kshenoy/vim-ctrlp-args'
nnoremap <C-G> :CtrlPArgs<Cr>

" Deals with surroundings
Plug 'tpope/vim-surround'

" Allows repetition of non-built-in commands
Plug 'tpope/vim-repeat'

" React-related plugins and tools
Plug 'mxw/vim-jsx'
let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" Linting
Plug 'sdeleon28/ale'
let g:ale_emit_conflict_warnings = 1
let g:ale_linters = { 'javascript': ['eslint', 'flow'] }
let g:ale_fixers = {
  \ 'html':['prettier'],
  \ 'css':['prettier'],
  \ 'rust': ['rustfmt'],
  \ 'json':['prettier'],
  \ 'markdown': ['prettier'],
  \ 'javascript': ['eslint', 'prettier'],
  \ 'typescript': ['eslint', 'tslint', 'prettier'],
  \ 'reason': ['refmt'],
  \ 'haskell': ['brittany']
  \ }

" Custom text-object plugins
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-line'
onoremap i/ :<c-u>execute "normal! T/vt/"<CR>
onoremap a/ :<c-u>execute "normal! F/vf/"<CR>

" Version control
Plug 'tpope/vim-fugitive'
nnoremap <LEADER>gs :aboveleft :20Gstatus<CR>
set diffopt=vertical

" Mappings por next/previous commands
Plug 'tpope/vim-unimpaired'

" Comment stuff out
Plug 'tpope/vim-commentary'

" Python mode!
Plug 'python-mode/python-mode'

" Theme
Plug 'Rigellute/rigel'
Plug 'pangloss/vim-javascript'
" Once vim-javascript is installed you enable flow highlighting
let g:javascript_plugin_flow = 1
Plug 'itchyny/lightline.vim'
let g:rigel_lightline = 1
let g:lightline = { 'colorscheme': 'rigel' }
Plug 'sheerun/vim-polyglot'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" Auto-close
Plug 'spf13/vim-autoclose'
let g:autoclose_vim_commentmode = 1
" inoremap {,<CR> {},<Esc>hi<CR><Esc>O
" inoremap {;<CR> {};<Esc>hi<CR><Esc>O
" inoremap {<CR> {}<Esc>hi<CR><Esc>O
" inoremap [,<CR> [],<Esc>hi<CR><Esc>O
" inoremap [;<CR> [];<Esc>hi<CR><Esc>O
" inoremap [<CR> []<Esc>hi<CR><Esc>O
" inoremap (,<CR> (),<Esc>hi<CR><Esc>O
" inoremap (;<CR> ();<Esc>hi<CR><Esc>O
" For some reason, the next one behaves differently. I don't use that syntax
" very often so I won't even bother.
" inoremap (<CR> ()<Esc>hi<CR><Esc>O

" Navigate through Vim and tmux splits seamlessly
Plug 'christoomey/vim-tmux-navigator'
" Hack to make C-H binding work in NeoVim. Read more at:
" https://github.com/christoomey/vim-tmux-navigator#it-doesnt-work-in-neovim-specifically-c-h
nnoremap <silent> <BS> :TmuxNavigateLeft<CR>

" GitGrep
Plug 'henrik/git-grep-vim'

" Swap windows
Plug 'wesQ3/vim-windowswap'

" Markdown
" source ~/vim/vimrc/plugins/markdown.vim

" My first plugin: A task manager for Vim
Plug 'sdeleon28/vim-todo'

" Support local vimrc files in your projects
Plug 'embear/vim-localvimrc'
let g:localvimrc_ask = 0

" Inline evaluation
" TODO: Check this out
" Plug 'metakirby5/codi.vim'

" Cheatsheets
" TODO: Check this out
" Plug 'dbeniamine/cheat.sh-vim'

" ReasonML
Plug 'reasonml-editor/vim-reason-plus'
