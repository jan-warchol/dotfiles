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

set ignorecase " Do case insensitive matching
set smartcase " Do smart case matching

" Ensure 8 lines of context is visible when jumping between search matches.
" I think it's better than mapping n to nzz (centering screen on every match).
nnoremap <silent> n :set scrolloff=8<CR>n:set scrolloff=2<CR>
nnoremap <silent> N :set scrolloff=8<CR>N:set scrolloff=2<CR>
nnoremap <silent> * :set scrolloff=8<CR>*:set scrolloff=2<CR>
nnoremap <silent> # :set scrolloff=8<CR>#:set scrolloff=2<CR>
" Center *first* search match (http://vi.stackexchange.com/q/10775/836)
cnoremap <expr> <CR> getcmdtype() =~ '[/?]' ? '<CR>zz' : '<CR>'

" Search highlighting
set hlsearch


 
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
" cursor would sometimes lag for several seconds when moving (especially when
" there were a lot of brackets/braces in the file).
" I found someone who was having similar problem, and he solved it by using
" old regex engine - see https://github.com/xolox/vim-easytags/issues/88
set regexpengine=1

" check for outside changes of the file more often
autocmd CursorHold * checktime

" enable persistent undo (remember changes after closing file)
set undofile

" save all temporary vim files to ~/.vim, rather than pollute projects with
" them. Note the // at the end (for storing full paths of edited files).
set directory=$HOME/.vim/swap//
set backupdir=$HOME/.vim/backup//
set undodir=$HOME/.vim/undo//

" save clipboard register on exit and suspend - http://stackoverflow.com/a/9381778/2058424
autocmd VimLeave * call system("xsel -ib", getreg('+'))
noremap <silent> <C-z> :call system("xsel -ib", getreg('+'))<CR><C-z>



" PLUGINS ==============================================================

" Manage plugins with Vim-Plug (github.com/junegunn/vim-plug)
call plug#begin('~/.vim/plugged')
" Let's get the obvious out of the way
Plug 'tpope/vim-sensible'

" Appearance -----------------------------------------------------------
Plug 'altercation/vim-colors-solarized'  " not used, just for comparison
Plug 'berdandy/ansiesc.vim'  " defines 'AnsiEsc' command that evaluates Ansi color codes
Plug 'ap/vim-css-color'  " display approximation of hex color codes inside vim
Plug 'docker/docker', { 'rtp': '/contrib/syntax/vim/' }
Plug 'chase/vim-ansible-yaml'  " syntax highlighting for Ansible
Plug 'lepture/vim-jinja'  " syntax highlighting for Jinja
Plug 'jeffkreeftmeijer/vim-numbertoggle'  " relative line numbers in normal, absolute in insert
let g:UseNumberToggleTrigger=0  " don't overwrite C-n mapping
Plug 'vim-scripts/vim-airline'
let g:airline#extensions#branch#displayed_head_limit = 18
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Additional interface elements ----------------------------------------
Plug 'tpope/vim-vinegar'
Plug 'sjl/gundo.vim'
Plug 'junegunn/vim-peekaboo'  " previewing register content
Plug 'junegunn/fzf'  " TODO: configure vim to use my FZF installation
Plug 'junegunn/fzf.vim'
" Enable history of patterns used in each FZF command
let g:fzf_history_dir = '~/.local/share/fzf-history'
Plug 'qpkorr/vim-bufkill'
Plug 'tpope/vim-fugitive'

" General behavior -----------------------------------------------------
Plug 'Carpetsmoker/auto_autoread.vim' " autodetect changes in file (bugged, needs enabling)
Plug 'Townk/vim-autoclose'  " automatically insert closing parens etc.

" New text objects definitions -----------------------------------------
Plug 'michaeljsmith/vim-indent-object'
Plug 'vim-scripts/tComment'
Plug 'kana/vim-textobj-user' " required by vim-textobj-line
Plug 'kana/vim-textobj-line' " allows selecting 'inner' line (without newline char)

" Navigation/motions ---------------------------------------------------
Plug 'jeetsukumaran/vim-indentwise'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'easymotion/vim-easymotion'
let g:EasyMotion_keys = 'hlnrasetoiygqwdfujbk:,.34-xzcmvp'
" TODO: make easymotion don't try so many words so that i don't loose
" single-letter shortcuts
" also, I think I want to replace default F and T bindings with easymotion!

Plug 'junegunn/vim-easy-align'  " better than godlygeek/tabular

" Make register behaviour more resonable
Plug 'svermeulen/vim-easyclip'
"" Map x to cut 
let g:EasyClipUseCutDefaults = 0
nmap x <Plug>MoveMotionPlug
xmap x <Plug>MoveMotionXPlug
nmap xx <Plug>MoveMotionLinePlug
"" Map s to substitute 
let g:EasyClipUseSubstituteDefaults = 1

Plug 'ktonga/vim-follow-my-lead'
let g:fml_all_sources = 1
call plug#end()



" COMMANDS AND TEXT OBJECTS ============================================

call textobj#user#plugin('yaml', {
\   'dictvalue': {
\     'pattern': '\(: \)\@<=.*$',
\     'select': ['ay', 'iy'],
\   },
\ })

" Fuzzy-find in all files, excluding .git data subdirectories (but including
" .git/config, .git/HEAD etc.)
command! -bang -nargs=? -complete=dir AllFiles call
  \ fzf#vim#files(<q-args>,
  \     {'source': "find . -mindepth 1 -type d -a -path '*/.git/*' -prune -o -print | cut -c 3- "},
  \     <bang>0)



" MAPPINGS =============================================================

let mapleader = "\<Space>"

map <Leader> <Plug>(easymotion-prefix)

" vinegar
nmap <Leader>l <Plug>VinegarUp
nmap <buffer> <Leader>l <Plug>VinegarUp

" FZF
nmap <Leader>oi :Buffers<CR>
nmap <Leader>on :Files<CR>
nmap <Leader>oh :AllFiles<CR>
nmap <Leader>ow :Windows<CR>
nmap <Leader>ol :Lines<CR>
nmap <Leader>om :History<CR>
nmap <Leader>rc :History:<CR>
nmap <Leader>rs :History/<CR>
" additional fuzyy-search directory targets
nmap <Leader>o~ :Files ~<CR>
nmap <Leader>ot :Files ~<CR>
nmap <Leader>o/ :Files /<CR>
nmap <Leader>oe :Files /etc<CR>
nmap <Leader>os :Files ~/src<CR>
nmap <Leader>oa :AllFiles ~<CR>
nmap <Leader>oc :AllFiles ~/.config<CR>

" Ctrl-S and Ctrl-Q are unused by default
nnoremap <C-S> :w<CR>
inoremap <C-S> <Esc>:w<CR>
nnoremap <C-Q> :qall<CR>
inoremap <C-Q> <Esc>:qall<CR>


" consistency ----------------------------------------------------------

" open new file in horizontal/vertical split. By default there is only mapping
" for horizontal split (<C-W>n).
nnoremap <C-W>nx :new<CR>
nnoremap <C-W>nv :vnew<CR>

" swap horizontal split with exchanging windows. This is mainly for
" consistency (many plugins etc. use C-X for opening horizontal splits)
nnoremap <C-W>x <C-W>s
nnoremap <C-W>s <C-W>x

" default behaviour of these two simply annoys me 
inoremap <C-Z> <C-O><C-Z>
nmap U u

" Remap jumping to free Ctrl-I (and Tab, which is hardwired to Ctrl-I)
nnoremap <C-N> <C-I>


" other ----------------------------------------------------------------
nnoremap <Leader>v :source $MYVIMRC<CR><C-L>

set pastetoggle=<F5>

" search for visually selected text. Note the no-magic setting!
vnoremap // "vy/\V<C-R>v<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


" unused keys ----------------------------------------------------------
" I keep a list to remember what I still have available.
map , <Nop>
map - <Nop>
map _ <Nop>
map <tab> <Nop>
map <C-P> <Nop>
map \ <Nop>
" Leader: a c d h j l m p q u x y z



" OTHER SETTINGS =======================================================

" colorscheme must be set after Vim-plug finishes its work
colorscheme selenized



" TODOs ================================================================

" Plugins to investigate:
"
" glts/vim-textobj-indblock
" nerdcomment
" reedes/vim-textobj-sentence
" garbas/vim-snipmate
" kbarrette/mediummode
" machakann/vim-sandwich



" FILETYPE SPECIFIC (INDENTATION, COLORING, AUTOCOMPLETION) ============

" Plugins:
" omnicomplete
" pearofducks/ansible-vim
" Valloric/YouCompleteMe
" syntastic
" supertab
" https://github.com/majutsushi/tagbar

" YAML indentation problems - if they return, this may help dealing with them
" http://stackoverflow.com/a/32420855/2058424
" :setlocal noautoindent
" :setlocal nocindent
" :setlocal nosmartindent
" :setlocal indentexpr=



" NATURAL MOVEMENT =====================================================

" " don't move cursor when leaving insert mode
" " http://vim.wikia.com/wiki/Prevent_escape_from_moving_the_cursor_one_character_to_the_left
" " http://stackoverflow.com/a/17054564/2058424
" let CursorColumnI = 0 "the cursor column position in INSERT
" autocmd InsertEnter * let CursorColumnI = col('.')
" autocmd CursorMovedI * let CursorColumnI = col('.')
" autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif

" don't move cursor when exiting insert mode
"inoremap <Esc> <Esc>`^
"https://zenbro.github.io/2015/07/24/auto-change-keyboard-layout-in-vim.html
"keymap

" " let arrows and h,l move cursor accross newlines
" set whichwrap+=h,l,<,>,[,]

" " move on soft lines in insert mode
" inoremap <Down> <C-o>g<Down>
" inoremap <Up> <C-o>g<Up>

" noremap <silent> j gj
" noremap <silent> k gk
" noremap <Down> gj
" noremap <Up> gk

" more fine-grained control over scrolling
" CAREFUL, this may had been the cause of some crashes I experienced.

" CAREFUL, this may had been the cause of some crashes I experienced.
"
" would allow changing escape behaviour so that it doensn't move cursor,
" as well as make it possible to e.g. do backward deletions (currently
" when the cursor is on the last char of a word and you say 'db' it will
" not delete this character. having this on would allow to move one char
" further and then be able to delete the word correctly.
"set virtualedit=onemore



" MOVEMENT MODIFIERS ===================================================
"
"Currently in normal mode shift-arrows and control-arrows do the same.  Maybe
"I could use them for something different?  E.g. control-arrows move to the
"beginning of the word, and shift-arrows to the end?  Just like in most
"editors, where the direction you're going affects whether you land at word's
"beginning or end.

" check this plugin
" bkad/CamelCaseMotion

"Also, think whether hjkl (or rather the equivalent in my layout) and their
"control and shift combinations should do exactly the same as arrows and their
"combinations, or maybe I should rather take advantage of having many keys?

"when moving by word, jump two words if there is a one-letter word next to
"ordinary one (e.g. in /paths/like/this)

"make control-arrows jump words instead of Words
"make ctrl-shift-arrow move by Words
"make ctrl-backspace work
"make control-arrow don't move to the next line if the cursor is not on line
"end

"What about using control-arrows for pane navigation? (but that could be done
"only in normal mode - in insert mode I need ctrl-arrows too much).

" potrzebuję sposobu na poruszanie się po słowach oddzielonych _ i - i / (a
" czasami traktowanie ich jako jedno słowo

"backspace in normal mode doesn't do anything useful (just moves left like h),
"so what about making it delete words? note that deleting words backwards in
"vim sometimes behaves strangely (try doing db when cursor is on the last
"letter).

" use backspace and enter for something in normal mode (maybe actually make backspace do backspace?)
" consider adding a mapping for inserting spaces/newlines without leaving normal mode - see https://www.reddit.com/r/vim/comments/3a1y8v/i_just_realized_backspace_doesnt_do_much_in/cs9a1g9

" make return noop in normal mode again, use ctrl-return for breaking lines.
" Similarly with backspace.

" " break line in normal mode
" nnoremap <CR> i<CR><ESC>




" INTERFACE ============================================================

" autohighlight word under cursor, but with some non-intrusive colors

" change cursor color - it should always be a reverse.

" highlighting window/flashing cursor when switching panes

" Navigating filesystem (NERDTree etc.)
" Problems with vinegar and netrw:
" - they break C-^ (directory view is remembered as last opened file)

" I think I need navigation shortcuts for :bn :bp (and perhaps moving buffers
" in the list). I also need a shortcut for repeating last operation.
" Apparently this is @: - need to check whether it's good in daily usage.
" submodes (https://github.com/kana/vim-submode) may be a good idea for
" related stuff.
" https://vi.stackexchange.com/questions/3632/how-to-repeat-a-mapping-when-keeping-key-pressed
" https://vi.stackexchange.com/questions/3978/can-i-repeat-the-last-ui-command?rq=1

" Do przemyślenia: kiedy mam otwartych kilka okien z różnymi plikami i z
" jednym już skończyłem, co właściwie chcę zrobić? zamknąć plik? wyświetlić
" poprzedni w oknie czy zostawić puste okno?

" Show in airline which buffer is the previous one (#)
" see also
" https://github.com/vim-airline/vim-airline/issues/1108
" https://github.com/vim-airline/vim-airline/issues/1149

" Dlaczego w :Buffers nie można zaznaczyć kilku plików?

" define new command for opening only selected files in window splits, and add
" it to fzf

" To głupie że Ctrl-6 przełącza do ostatniego pliku nawet jeśli został
" zamknięty. Chciałbym żeby przełączał do poprzedniego otwartego pliku.

" żeby poruszać się między oknami, trzeba wyjść z insert mode. Jest to dość
" wkurzające. Może mapowania które działają w insert?

" obecne mapowania na fuzzy-otwieranie często powodują przypadkowe przejście
" do insert mode i jest to niebywale wkurzające.


" MISCELLANEOUS ========================================================

" sometimes when pressing enter i want vim to automatically add some prefix:
" - autoindentation
" - a comment symbol if I'm inside comment
" - a list element marker (i.e. `-` or `*`)
" - something else?
" But sometimes I don't want this.  So, probably I need to map shift-enter
" (or control-enter) to do the opposite.

" two different approaches for controlling text width:
" http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns#3765575
"reflow text during formatting
"set formatoptions=ant
"set textwidth=79

" zaznaczenie obiektu wcięcia z nagłówkiem (definicją funkcji) ale bez
" whitespace'a

