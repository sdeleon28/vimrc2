set termguicolors
syntax enable
colorscheme rigel
set background=dark
set t_Co=256
let g:lightline = {
      \ 'colorscheme': 'rigel',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'gitbranch', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }

function! LightlineFilename()
  let s:project_dir = getcwd()
  let s:full_path = expand('%:p')
  return substitute(s:full_path, s:project_dir . '/', '', '')
endfunction
