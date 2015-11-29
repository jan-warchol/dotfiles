" APPEARANCE

set title
set number
set scrolloff=2
set sidescrolloff=5

" Search highlighting with modified coloring
set hlsearch
highlight Search cterm=reverse ctermfg=NONE ctermbg=NONE
highlight Visual cterm=reverse ctermfg=NONE  ctermbg=NONE
" Clear highlighting on escape in normal mode
nnoremap <silent> <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[


" BEHAVIOUR

" let arrows and h,l move cursor accross newlines
set whichwrap+=h,l,<,>,[,]

set expandtab
set tabstop=8
set shiftwidth=2
set ignorecase " Do case insensitive matching
set smartcase " Do smart case matching

" enable mouse support. This makes scrolling behave normally (moves content
" instead od moving cursor) and lets user select text with mouse.
set mouse=a

" new undo item when pressed CR
inoremap <CR> <C-G>u<CR>


" Leader commands
let mapleader = "\<Space>"
nnoremap <Leader>q :q<CR>


" Plugins managed by Vim-Plug (github.com/junegunn/vim-plug)
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'michaeljsmith/vim-indent-object'

" TODO: plugins to investigate
"Valloric/YouCompleteMe
"vim-airline (!)
"align
"autoclose (!)
"asynccommand
"colorpack (!)
"ctrlp (!)
"easymotion
"gist
"nerdcomment
"omnicppcomplete
"snipMate (!)
"supertab (!)
"syntastic (!)
"(!) means that the plugin is super awesome. 
call plug#end()

" TODO: settings to try out
"
" don't move cursor when exiting insert mode
"inoremap <Esc> <Esc>`^
"https://zenbro.github.io/2015/07/24/auto-change-keyboard-layout-in-vim.html
"keymap
"
"reflow text during formatting
"set formatoptions=ant
"
"set textwidth=79
"
"map ctrl-s in insert mode to save

" TODO: how to do these?
"
"make control-arrows jump words instead of Words
"make ctrl-shift-arrow move by Words
"make ctrl-backspace work
"
"define a command that deletes selection without putting it into any clipboard
"(i.e. delete instead of cut).  Maybe map it to x?
"
"autohighlight word under cursor, but with some non-intrusive colors
"
"make copying and pasting to system clipboard work with some reasonable
"shortcut.
