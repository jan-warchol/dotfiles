set whichwrap+=h,l,<,>,[,]
set number

map q :qa<CR>

" Plugins managed by Vim-Plug (github.com/junegunn/vim-plug)
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
call plug#end()
