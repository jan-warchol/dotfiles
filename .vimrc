" APPEARANCE ===========================================================

set title
set number
set scrolloff=2
set sidescrolloff=5
set cursorline

" soft-wrap lines only on word boundaries
set linebreak

" Allow color schemes to do bright colors without forcing bold.
" This must be done before colorscheme settings, and also must be set here so
" that sensible-vim will not set it on its own (see
" https://github.com/tpope/vim-sensible/issues/74)
set t_Co=16



" SEARCHING ============================================================

" Ensure more context is visible when jumping between search matches.
" Some people map n to nzz (centering screen on every match), but I like this
" better.
nnoremap <silent> n :set scrolloff=8<CR>n:set scrolloff=2<CR>
nnoremap <silent> N :set scrolloff=8<CR>N:set scrolloff=2<CR>
nnoremap <silent> * :set scrolloff=8<CR>*:set scrolloff=2<CR>
nnoremap <silent> # :set scrolloff=8<CR>#:set scrolloff=2<CR>
" Center *first* search match (http://vi.stackexchange.com/q/10775/836)
cnoremap <expr> <CR> getcmdtype() =~ '[/?]' ? '<CR>zz' : '<CR>'

" Search highlighting
set hlsearch
" " Clear highlighting on escape in normal mode
" nnoremap <silent> <esc> :noh<return><esc>
" nnoremap <esc>^[ <esc>^[

set ignorecase " Do case insensitive matching
set smartcase " Do smart case matching



" CURSOR MOVEMENT ======================================================

" " don't move cursor when leaving insert mode
" " http://vim.wikia.com/wiki/Prevent_escape_from_moving_the_cursor_one_character_to_the_left
" " http://stackoverflow.com/a/17054564/2058424
" let CursorColumnI = 0 "the cursor column position in INSERT
" autocmd InsertEnter * let CursorColumnI = col('.')
" autocmd CursorMovedI * let CursorColumnI = col('.')
" autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif

" " let arrows and h,l move cursor accross newlines
" set whichwrap+=h,l,<,>,[,]

" " move on soft lines in insert mode
" inoremap <Down> <C-o>g<Down>
" inoremap <Up> <C-o>g<Up>

" noremap <silent> j gj
" noremap <silent> k gk
" noremap <Down> gj
" noremap <Up> gk

 
 
" BEHAVIOUR ============================================================

" more intuitive placement of new vertical and horizontal splits
set splitbelow
set splitright

set expandtab
set tabstop=8
set shiftwidth=2

" enable mouse support. This makes scrolling behave normally (moves content
" instead od moving cursor) and lets user select text with mouse.
set mouse=a

"Enable middle mouse button clipboard support
set guioptions+=a

" Automatically use system wide clipboard
set clipboard=unnamedplus

" Allow having multiple files with unsaved changes opened simultaneously
set hidden

" new undo item when pressed CR
inoremap <CR> <C-G>u<CR>

" I was getting terrible vim performance on some Ansible playbook files - the
" cursor would lag when moving, sometimes the lag would reach several seconds!
" (it seeemed to be especially bad when there were a lot of brackets/braces in
" the file).
" I found someone who was having similar problem, and he solved it by using
" old regex engine - see https://github.com/xolox/vim-easytags/issues/88
set regexpengine=1

" "Preview unsaved changes
" command! Showchanges w !diff % -

" check for outside changes of the file more often
autocmd CursorHold * checktime

" enable persistent undo (remember changes after closing file)
set undofile



" NEW MAPPINGS =========================================================

" set pastetoggle=<F5>

" Leader commands
let mapleader = "\<Space>"
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :q!<CR>
nnoremap <Leader>wq :wq<CR>
nnoremap <Leader>c :bd<CR>
nnoremap <Leader>wc :w<CR>:bd<CR>
nnoremap <Leader>s :w<CR>
nnoremap <Leader><Tab> :CtrlPBuffer<CR>
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

" Show syntax highlighting groups for word under cursor
nmap <C-S-M> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc



" REMAPS OF EXISTING KEYS ==============================================

nnoremap <C-S> :w<CR>
inoremap <C-S> <Esc>:w<CR>
nnoremap <C-Q> :q<CR>
inoremap <C-Q> <Esc>:q<CR>

" " break line in normal mode
" nnoremap <CR> i<CR><ESC>



" PLUGINS ==============================================================

" Manage plugins with Vim-Plug (github.com/junegunn/vim-plug)
call plug#begin('~/.vim/plugged')
" Let's get the obvious out of the way
Plug 'tpope/vim-sensible'

" Appearance -----------------------------------------------------------
Plug 'altercation/vim-colors-solarized'  " not used, just for comparison
Plug 'berdandy/ansiesc.vim'  " defines 'AnsiEsc' command that evaluates Ansi color codes
Plug 'ap/vim-css-color'  " display approximation of hex color codes inside vim
Plug 'chase/vim-ansible-yaml'  " syntax highlighting for Ansible
Plug 'jeffkreeftmeijer/vim-numbertoggle'  " relative line numbers in normal, absolute in insert
let g:UseNumberToggleTrigger=0  " don't overwrite C-n mapping
Plug 'vim-airline'
let g:airline#extensions#branch#displayed_head_limit = 25

" Additional interface elements ----------------------------------------
Plug 'scrooloose/nerdtree'
Plug 'sjl/gundo.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-fugitive'

" General behavior -----------------------------------------------------
Plug 'Carpetsmoker/auto_autoread.vim' " autodetect changes in file (bugged, needs enabling)
Plug 'Townk/vim-autoclose'  " automatically insert closing parens etc.

" New text objects definitions -----------------------------------------
Plug 'michaeljsmith/vim-indent-object'
Plug 'tComment'
Plug 'kana/vim-textobj-user' " required by vim-textobj-line
Plug 'kana/vim-textobj-line' " allows selecting 'inner' line (without newline char)

" Navigation/motions ---------------------------------------------------
Plug 'jeetsukumaran/vim-indentwise'
Plug 'terryma/vim-multiple-cursors' "overrides default C-n and C-p mappings
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'easymotion/vim-easymotion'
let g:EasyMotion_keys = 'hlnrasetoiygcmvp'

" better than godlygeek/tabular
Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Plug 'terryma/vim-expand-region'
" vmap v <Plug>(expand_region_expand)
" vmap <C-V> <Plug>(expand_region_shrink)

" Make register behaviour more resonable
Plug 'svermeulen/vim-easyclip'
"" Map x to cut 
let g:EasyClipUseCutDefaults = 0
nmap x <Plug>MoveMotionPlug
xmap x <Plug>MoveMotionXPlug
nmap xx <Plug>MoveMotionLinePlug
"" Map s to substitute 
let g:EasyClipUseSubstituteDefaults = 1

call plug#end()

" colorscheme must be set after Vim-plug finishes its work
colorscheme selenized



" TODOs ================================================================

" Plugins to investigate:
"
" Valloric/YouCompleteMe
" https://github.com/majutsushi/tagbar
" asynccommand
" gist
" nerdcomment
" omnicppcomplete
" supertab (!)
" syntastic (!)
" (!) means that the plugin is super awesome. 
" reedes/vim-textobj-sentence
" garbas/vim-snipmate
" pearofducks/ansible-vim
" kbarrette/mediummode
" machakann/vim-sandwich
" bkad/CamelCaseMotion

" two different approaches for controlling text width:
" http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns#3765575

" make return noop in normal mode again, use ctrl-return for breaking lines.
" Similarly with backspace.

" don't move cursor when exiting insert mode
"inoremap <Esc> <Esc>`^
"https://zenbro.github.io/2015/07/24/auto-change-keyboard-layout-in-vim.html
"keymap

"reflow text during formatting
"set formatoptions=ant
"set textwidth=79

" would allow changing escape behaviour so that it doensn't move cursor,
" as well as make it possible to e.g. do backward deletions (currently
" when the cursor is on the last char of a word and you say 'db' it will
" not delete this character. having this on would allow to move one char
" further and then be able to delete the word correctly.
"set virtualedit=onemore

"backspace in normal mode doesn't do anything useful (just moves left like h),
"so what about making it delete words? note that deleting words backwards in
"vim sometimes behaves strangely (try doing db when cursor is on the last
"letter).

"Currently in normal mode shift-arrows and control-arrows do the same.  Maybe
"I could use them for something different?  E.g. control-arrows move to the
"beginning of the word, and shift-arrows to the end?  Just like in most
"editors, where the direction you're going affects whether you land at word's
"beginning or end.

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
" zaznaczenie obiektu wcięcia z nagłówkiem (definicją funkcji) ale bez
" whitespace'a
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

" configure some key combination in insert mode (perhaps control-enter or
" shift-enter) to do what "O" does in normal mode

