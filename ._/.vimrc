" APPEARANCE ===========================================================

set title
set number
set scrolloff=2
set sidescrolloff=5
set cursorline

" soft-wrap lines only on word boundaries
set linebreak
set nowrap

" Allow color schemes to do bright colors without forcing bold.
" This must be done before colorscheme settings, and also must be set here so
" that sensible-vim will not set it on its own (see
" https://github.com/tpope/vim-sensible/issues/74)
set t_Co=16

" 15 because I'm using a display with high pixel density at home
set guifont=Ubuntu\ Mono\ 15



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

" Use <F8> to clear search highlighting
nnoremap <silent> <F8> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

 
" BEHAVIOUR ============================================================

" more intuitive placement of new vertical and horizontal splits
set splitbelow
set splitright

" autoresize splits on window resize (so that they are equal size)
autocmd VimResized * wincmd =

set expandtab
set tabstop=8
set shiftwidth=2

" enable mouse support. This makes scrolling behave normally (moves content
" instead od moving cursor) and lets user select text with mouse.
set mouse=a

"Enable middle mouse button clipboard support
set guioptions+=a

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
set viminfo+=n$HOME/data/viminfo-$DISAMBIG_SUFFIX



" PLUGINS ==============================================================

" Manage plugins with Vim-Plug (github.com/junegunn/vim-plug)
call plug#begin('~/.vim/plugged')
" Let's get the obvious out of the way
Plug 'tpope/vim-sensible'

" Appearance -----------------------------------------------------------
Plug 'altercation/vim-colors-solarized'  " not used, just for comparison
Plug 'lifepillar/vim-colortemplate'  " colorscheme designer toolkit
Plug 'berdandy/ansiesc.vim'  " defines 'AnsiEsc' command that evaluates Ansi color codes
Plug 'sheerun/vim-polyglot'  " set of syntax rules for many languages
Plug 'ap/vim-css-color'  " display approximation of hex color codes inside vim
Plug 'posva/vim-vue'  " syntax highlighting for JavaScript framework Vue
Plug 'derekwyatt/vim-scala'  " syntax highlighting for scala
Plug 'lepture/vim-jinja'  " syntax highlighting for Jinja
Plug 'vim-scripts/SyntaxAttr.vim'  " for debugging syntax highlighting

Plug 'itchyny/lightline.vim'
let g:lightline = { 'mode_map': { 'R' : 'OVERWR', }, }
let g:lightline.colorscheme = '16color'
set noshowmode  " status info is no longer needed with lightline

" Additional interface elements ----------------------------------------
Plug 'preservim/nerdtree'
Plug 'sjl/gundo.vim'
Plug 'junegunn/vim-peekaboo'  " previewing register content
Plug 'junegunn/fzf'  " TODO: configure vim to use my FZF installation
Plug 'junegunn/fzf.vim'
" Enable history of patterns used in each FZF command
let g:fzf_history_dir = $FZF_VIM_HISTORY
Plug 'qpkorr/vim-bufkill'
Plug 'tpope/vim-fugitive'

" General behavior -----------------------------------------------------

" New text objects definitions -----------------------------------------
Plug 'michaeljsmith/vim-indent-object'
Plug 'vim-scripts/tComment'
Plug 'kana/vim-textobj-user' " required by vim-textobj-line
Plug 'kana/vim-textobj-line' " allows selecting 'inner' line (without newline char)

" Navigation/motions ---------------------------------------------------
Plug 'jeetsukumaran/vim-indentwise'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'  " required by vim-easyclip (and useful on its own)

Plug 'junegunn/vim-easy-align'  " better than godlygeek/tabular

" Make register behaviour more resonable
Plug 'svermeulen/vim-easyclip'  " requires repeat.vim
call plug#end()



" SANE CLIPBOARD =======================================================

" Requires svermeulen/vim-easyclip plugin and +clipboard. See also
" http://vimcasts.org/blog/2013/11/registers-the-good-the-bad-and-the-ugly-parts/

" Automatically use system-wide clipboard (the one tied to Ctrl-C/X/V; use
" 'unnamed' for middle-mouse-button clipboard)
set clipboard=unnamedplus

" save clipboard register on exit and suspend - http://stackoverflow.com/a/9381778/2058424
autocmd VimLeave * call system("xsel -ib", getreg('+'))
noremap <silent> <C-z> :call system("xsel -ib", getreg('+'))<CR><C-z>

" Map s to substitute (replacement motion, no need for extra register)
let g:EasyClipUseSubstituteDefaults = 1

" Restore d as cutting operator. This is not ideal (I still don't have a
" convenient way to delete without putting in clipboard), but the alternative
" (replacing one of Vim's default mappings, like x or m, or using a longer
" mapping, like <Leader>d) sounds worse.
let g:EasyClipUseCutDefaults = 0
nmap d <Plug>MoveMotionPlug
xmap d <Plug>MoveMotionXPlug
nmap dd <Plug>MoveMotionLinePlug



" COMMANDS AND TEXT OBJECTS ============================================

if exists('textobj#user#plugin')
  call textobj#user#plugin('yaml', {
  \   'dictvalue': {
  \     'pattern': '\(: \)\@<=.*$',
  \     'select': ['ay', 'iy'],
  \   },
  \ })
endif

" MAPPINGS =============================================================

" Langmap is broken: it seems mappings are applied recursively. In the mapping
" below pressing K in normal mode results in cursor moving to the left (action
" from H key) rather than jumping to next search result (action from N key) :/
" set langmap=frFR,tfTF,\\,t<T,nhNH,rjRJ,lkLK,hlHL,pbPB,mpMP,knKN

map <F3> :set wrap!<CR>
imap <F3> <C-O>:set wrap!<CR>

let mapleader = "\<Space>"

nmap <Leader>a :call SyntaxAttr()<CR>


" NERDTree

" match FZF shortcuts for opening in new split or tab
autocmd FileType nerdtree nmap <buffer> <C-X> i
autocmd FileType nerdtree nmap <buffer> <C-V> s<CR>
autocmd FileType nerdtree nmap <buffer> <C-T> t

" switching between files and NERDtree. Remember that <tab> == <C-I>
map <tab> :NERDTreeFocus<CR>
autocmd FileType nerdtree nmap <buffer> <tab> <C-W>p
" focusing on opened file in NERDtree
map <leader>f :NERDTreeFind<CR>
" don't switch to opened file when using Enter to open it
let NERDTreeCustomOpenArgs = {'file': {'where':'p', 'keepopen':1, 'stay':1}}

" close Vim if the only open window is NERDtree
" https://github.com/preservim/nerdtree/wiki/F.A.Q.
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" let <C-Q> close last window with the code
autocmd FileType nerdtree nmap <buffer> <C-Q> <C-W>p:q<CR>


" Fuzzy-find in all files (including hidden)
command! -bang -nargs=? -complete=dir FilteredFiles call
  \ fzf#vim#files(<q-args>,
  \     {'source': "smart-find -type f"},
  \     <bang>0)

" Fuzzy-find in dotfiles
command! -bang -nargs=? -complete=dir DotFiles call
  \ fzf#vim#files(<q-args>,
  \     {'source': "ls-dotfiles",
  \     'options': '--prompt="Dotfiles: "'},
  \     <bang>0)

" FZF

" Avoid opening files in NERDTree buffer.
" https://github.com/junegunn/fzf/issues/453#issuecomment-354634207
function! FZFOpen(command_str)
  if (expand('%') =~# 'NERD_tree' && winnr('$') > 1)
    exe "normal! \<c-w>\<c-w>"
  endif
  exe 'normal! ' . a:command_str . "\<cr>"
endfunction

" This may also be interesting:
" " If more than one window and previous buffer was NERDTree, go back to it.
" autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif

nmap <Leader><Tab> :call FZFOpen(':Buffers')<CR>

nmap <Leader>on :call FZFOpen(':FilteredFiles')<CR>
nmap <Leader>oa :call FZFOpen(':Files')<CR>
nmap <Leader>oh :call FZFOpen(':FilteredFiles ~')<CR>
nmap <Leader>oe :call FZFOpen(':Files /etc')<CR>
nmap <Leader>og :call FZFOpen(':GFiles')<CR>
nmap <Leader>od :call FZFOpen(':DotFiles')<CR>

nmap <Leader>ow :Windows<CR>

" Ctrl-S, Ctrl-Q and Ctrl-C are unused by default! (they were used for flow
" control in terminals.) Use them to make common operations more intuitive.
nnoremap <C-S> :w<CR>
inoremap <C-S> <Esc>:w<CR>
" close buffer without affecting splits (requires qpkorr/vim-bufkill)
map <C-c> :BD<CR>
" close window/split (buffer stays open)
nnoremap <C-Q> :q<CR>
inoremap <C-Q> <Esc>:q<CR>
" Alt-Q to save changes and quit
nmap q :w<CR>:q<CR>
imap q <ESC>:w<CR>:q<CR>


" consistency ----------------------------------------------------------

" unlearn word-deletion shortcut
imap <C-W> <nop>

" open new file in horizontal/vertical split. By default there is only mapping
" for horizontal split (<C-W>n).
nnoremap <C-W>nx :new<CR>
nnoremap <C-W>nv :vnew<CR>

" swap horizontal split with exchanging windows. This is mainly for
" consistency (many plugins etc. use C-X for opening horizontal splits)
nnoremap <C-W>x <C-W>s
nnoremap <C-W>s <C-W>x

" Nawigate splits. This is such an important task that there really should be
" a first-level mapping for it.
nnoremap <silent> <C-Right> <c-w>l
nnoremap <silent> <C-Left> <c-w>h
nnoremap <silent> <C-Up> <c-w>k
nnoremap <silent> <C-Down> <c-w>j

" default behaviour of these two simply annoys me 
inoremap <C-Z> <C-O><C-Z>
nmap U u


" navigation -----------------------------------------------------------

" don't move cursor when leaving insert mode
" http://vim.wikia.com/wiki/Prevent_escape_from_moving_the_cursor_one_character_to_the_left
" http://stackoverflow.com/a/17054564/2058424
let CursorColumnI = 0 "the cursor column position in INSERT
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif
set virtualedit=onemore

" move by visual lines when the text is wrapped
noremap <Down> gj
noremap <Up> gk

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
map <C-O> <Nop>
" default K binding is useless...
map K <Nop>
map <C-l> :echo "Nope, use F8"<CR>
map \ <Nop>
" Leader: a c d h j l m p q u x y z
map <leader>d :colorscheme default<CR>
map <leader>j :colorscheme selenized_bw<CR>
map <leader>m :colorscheme selenized<CR>
map <leader>k :colorscheme selenized_alt<CR>
map <leader>s :colorscheme solarized<CR>
map <leader>e :colorscheme selenized_solarized<CR>
map <leader>c :colorscheme selenized_old<CR>

" Remap jumping in movement history, for 2 purposes:
" - to free Ctrl-O and Ctrl-I (and Tab, which is hardwired to Ctrl-I)
" - to make the movement more intuitive (key to the right moves forward)
nnoremap <C-N><C-O> <C-I>
nnoremap <C-N><C-I> <C-O>


" OTHER SETTINGS =======================================================

" colorscheme must be set after Vim-plug finishes its work
let g:selenized_green_keywords=0
set background=dark
colorscheme selenized
