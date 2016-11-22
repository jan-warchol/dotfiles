" APPEARANCE

set title
set number
set scrolloff=2
set sidescrolloff=5


" don't move cursor when leaving insert mode
let CursorColumnI = 0 "the cursor column position in INSERT
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif

" BEHAVIOUR

" let arrows and h,l move cursor accross newlines
set whichwrap+=h,l,<,>,[,]

" move on soft lines in insert mode
"inoremap <Down> <C-o>g<Down>
"inoremap <Up> <C-o>g<Up>

noremap <silent> j gj
noremap <silent> k gk
noremap <Down> gj
noremap <Up> gk

" Ensure more context is visible when jumping between search matches.
" Some people map n to nzz (centering screen on every match), but I like this
" better.
nnoremap <silent> n :set scrolloff=8<CR>n:set scrolloff=2<CR>
nnoremap <silent> N :set scrolloff=8<CR>N:set scrolloff=2<CR>
nnoremap <silent> * :set scrolloff=8<CR>*:set scrolloff=2<CR>
nnoremap <silent> # :set scrolloff=8<CR>#:set scrolloff=2<CR>

" wrap only on word boundaries
set linebreak

" more intuitive placement of new vertical and horizontal splits
set splitbelow
set splitright

set expandtab
set tabstop=8
set shiftwidth=2
set ignorecase " Do case insensitive matching
set smartcase " Do smart case matching

" enable mouse support. This makes scrolling behave normally (moves content
" instead od moving cursor) and lets user select text with mouse.
set mouse=a

" Automatically use system wide clipboard
set clipboard=unnamedplus

" Allow having multiple files with unsaved changes opened simultaneously
set hidden

" new undo item when pressed CR
inoremap <CR> <C-G>u<CR>
"Enable middle mouse button clipboard support
set guioptions+=a

set pastetoggle=<F5>

nnoremap <C-S> :w<CR>
inoremap <C-S> <Esc>:w<CR>
nnoremap <C-Q> :q<CR>
inoremap <C-Q> <Esc>:q<CR>

" Leader commands
let mapleader = "\<Space>"
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :q!<CR>
nnoremap <Leader>wq :wq<CR>
nnoremap <Leader>c :bd<CR>
nnoremap <Leader>wc :w<CR>:bd<CR>
nnoremap <Leader>s :w<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>v :source $MYVIMRC<CR><C-L>
vmap <Leader>y "+y
nnoremap <Leader>p "+p
nmap <Leader>{ ysiw{ysa{}w
nmap <Leader>} ysiw{ysa{}w
nmap <Leader>"{ ysiw{ysa{}ysa{"
nmap <Leader>yW ysiW{ysa{}ysa{"
nmap <Leader>yw ysiw{ysa{}ysa{"
nmap <Leader>yW ysiW{ysa{}ysa{"


" REMAPS

" make paragraph-jumping go to last line of the next paragraph when jumping
" downwards, and first line of the previous paragraph when jumping upwards.
nnoremap { k{<Space>0
vnoremap { k{<Space>0
nnoremap } j}<BS>0
vnoremap } j}<BS>0

" break line in normal mode
nnoremap <CR> i<CR><ESC>

"Preview unsaved changes
command! Showchanges w !diff % -

" I was getting terrible vim performance on some Ansible playbook files - the
" cursor would lag when moving, sometimes the lag would reach several seconds!
" (it seeemed to be especially bad when there were a lot of brackets/braces in
" the file).
" I found someone who was having similar problem, and he solved it by using
" old regex engine - see https://github.com/xolox/vim-easytags/issues/88
set regexpengine=1

" Plugins managed by Vim-Plug (github.com/junegunn/vim-plug)
call plug#begin('~/.vim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'michaeljsmith/vim-indent-object'
Plug 'vim-airline'
let g:airline#extensions#branch#displayed_head_limit = 25

Plug 'ctrlpvim/ctrlp.vim'
Plug 'chase/vim-ansible-yaml'
Plug 'tComment'

Plug 'scrooloose/nerdtree'

Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"Valloric/YouCompleteMe
"Tcomment

Plug 'terryma/vim-expand-region'
vmap v <Plug>(expand_region_expand)
vmap <C-V> <Plug>(expand_region_shrink)

" Make register behaviour more resonable
Plug 'svermeulen/vim-easyclip'
"" Map x to cut 
let g:EasyClipUseCutDefaults = 0
nmap x <Plug>MoveMotionPlug
xmap x <Plug>MoveMotionXPlug
nmap xx <Plug>MoveMotionLinePlug
"" Map s to substitute 
let g:EasyClipUseSubstituteDefaults = 1

Plug 'berdandy/ansiesc.vim'
Plug 'terryma/vim-multiple-cursors' "overrides default C-n and C-p mappings

Plug 'kana/vim-textobj-user' " required by vim-textobj-line
Plug 'kana/vim-textobj-line' " allows selecting 'inner' line (without newline char)


" TODO: plugins to investigate
" https://github.com/majutsushi/tagbar
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
"reedes/vim-textobj-sentence
"garbas/vim-snipmate
"scrooloose/nerdtree
"pearofducks/ansible-vim
call plug#end()

" Allow color schemes to do bright colors without forcing bold.
" This must be done before colorscheme settings, and also must be set here so
" that sensible-vim will not set it on its own (see
" https://github.com/tpope/vim-sensible/issues/74)
set t_Co=16

highlight DiffAdd cterm=none ctermfg=green ctermbg=black
highlight DiffDelete cterm=none ctermfg=darkred ctermbg=black
highlight DiffChange cterm=none ctermfg=none ctermbg=black
highlight DiffText cterm=none ctermfg=black ctermbg=darkyellow

highlight Comment ctermfg=gray
highlight CursorLine ctermbg=black cterm=NONE
set cursorline

" Search highlighting with modified coloring
set hlsearch
highlight Search cterm=reverse ctermfg=NONE ctermbg=NONE
highlight Visual cterm=NONE ctermfg=NONE  ctermbg=darkgray
" Clear highlighting on escape in normal mode
nnoremap <silent> <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[

" Show syntax highlighting groups for word under cursor
nmap <C-S-M> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
"
" TODO: settings to try out
"
" make return noop in normal mode again, use ctrl-return for breaking lines.
" Similarly with backspace.
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

"map ctrl-s in insert mode to save, because it's unused anyway (traditionally
"it was a terminal control flow binding)
"
" would allow changing escape behaviour so that it doensn't move cursor,
" as well as make it possible to e.g. do backward deletions (currently
" when the cursor is on the last char of a word and you say 'db' it will
" not delete this character. having this on would allow to move one char
" further and then be able to delete the word correctly.
"set virtualedit=onemore
"
"backspace in normal mode doesn't do anything useful (just moves left like h),
"so what about making it delete words? note that deleting words backwards in
"vim sometimes behaves strangely (try doing db when cursor is on the last
"letter).
"
"maybe make H (or equivalent in my keyboard layout) move by word, like b (or
"maybe like ge)?  In my current layout b is in an inconvenient spot.
"
"Currently in normal mode shift-arrows and control-arrows do the same.  Maybe
"I could use them for something different?  E.g. control-arrows move to the
"beginning of the word, and shift-arrows to the end?  Just like in most
"editors, where the direction you're going affects whether you land at word's
"beginning or end.
"
"Also, think whether hjkl (or rather the equivalent in my layout) and their
"control and shift combinations should do exactly the same as arrows and their
"combinations, or maybe I should rather take advantage of having many keys?
"
"Make C-Z work in insert mode (either as undo or as sending vim to background)
"
"Stuff that should be available in all modes (thus they should utilize
"shortcuts with control, rather than leader mappings):
"- saving file
"- opening new file/changing buffer
"- quitting? or closing buffer?

" TODO: how to do these?
"
" sometimes when pressing enter i want vim to automatically add some prefix:
" - autoindentation
" - a comment symbol if I'm inside comment
" - a list element marker (i.e. `-` or `*`)
" - something else?
" But sometimes I don't want this.  So, probably I need to map shift-enter
" (or control-enter) to do the opposite.
"
" don't break undo into lines when pasting a block of text
"
"make control-arrows jump words instead of Words
"make ctrl-shift-arrow move by Words
"make ctrl-backspace work
"make control-arrow don't move to the next line if the cursor is not on line
"end
"
"What about using control-arrows for pane navigation? (but that could be done
"only in normal mode - in insert mode I need ctrl-arrows too much).
"
"define a command that deletes selection without putting it into any clipboard
"(i.e. delete instead of cut).  Maybe map it to x?
"
"autohighlight word under cursor, but with some non-intrusive colors
"
"make copying and pasting to system clipboard work with some reasonable
"shortcut.
"
"when moving by word, jump two words if there is a one-letter word next to
"ordinary one (e.g. in /paths/like/this)
"
"find a motion to move by indentation level (or code blocks)
"
" use backspace and enter for something in normal mode (maybe actually make backspace do backspace?)
" consider adding a mapping for inserting spaces/newlines without leaving normal mode - see https://www.reddit.com/r/vim/comments/3a1y8v/i_just_realized_backspace_doesnt_do_much_in/cs9a1g9
