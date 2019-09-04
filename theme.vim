set termguicolors
syntax enable
colorscheme rigel
set background=dark
set t_Co=256
let g:lightline = {
      \ 'colorscheme': 'rigel',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ] ]
      \ }
      \ }
