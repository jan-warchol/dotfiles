set whichwrap+=h,l,<,>,[,]
set number
" Leader commands
let mapleader = "\<Space>"
nnoremap <Leader>q :q<CR>


" Plugins managed by Vim-Plug (github.com/junegunn/vim-plug)
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
call plug#end()
