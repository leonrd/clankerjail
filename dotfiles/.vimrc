set nocompatible
filetype on
filetype off

let s:dotvim = '~/.config/vim/'
set runtimepath+=~/.config/vim
set viminfo+=n~/.config/vim/viminfo

" Utils {{{
exec ':so '.s:dotvim.'/functions/util.vim'
" }}}

" Load external configuration before anything else {{{
let s:beforerc = expand(s:dotvim . '/before.vimrc')
if filereadable(s:beforerc)
    exec ':so ' . s:beforerc
endif
" }}}

" Change mapleader
let mapleader = ","
let maplocalleader = "\\"

" Local vimrc configuration {{{
let s:localrc = expand(s:dotvim . '/local.vimrc')
if filereadable(s:localrc)
    exec ':so ' . s:localrc
endif
" }}}

" PACKAGE LIST {{{

" Use this variable inside your local configuration to declare
" which package you would like to include
if ! exists('g:vimified_packages')
    let g:vimified_packages = ['general', 'fancy', 'coding']
endif
" }}}

" PACKAGES {{{
call plug#begin()

" Install user-supplied packages {{{
let s:extrarc = expand(s:dotvim . '/extra.vimrc')
if filereadable(s:extrarc)
    exec ':so ' . s:extrarc
endif
" }}}

" _. General {{{
if count(g:vimified_packages, 'general')
    Plug 'editorconfig/editorconfig-vim'

    Plug 'junegunn/vim-easy-align'
    Plug 'tpope/vim-endwise'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-speeddating'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'
    Plug 'maxbrunsfeld/vim-yankstack'
    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-vinegar'

    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    " Disable the scrollbars (NERDTree)
    set guioptions-=r
    set guioptions-=L
    " Keep NERDTree window fixed between multiple toggles
    set winfixwidth
    " Show hiddend files in NERDTree
    let NERDTreeShowHidden=1
    " Show NERDTreee by default
    " au VimEnter * NERDTreeToggle
    nmap <tab> :NERDTreeToggle<cr>
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'Xuyuanp/nerdtree-git-plugin'


    Plug 'kana/vim-textobj-user'
    Plug 'vim-scripts/YankRing.vim'
    let g:yankring_replace_n_pkey = '<leader>['
    let g:yankring_replace_n_nkey = '<leader>]'
    let g:yankring_history_dir = s:dotvim.'/tmp/'
    nmap <leader>y :YRShow<cr>

    Plug 'michaeljsmith/vim-indent-object'
    let g:indentobject_meaningful_indentation = ["haml", "sass", "python", "yaml", "markdown"]

    Plug 'Spaceghost/vim-matchit'
    Plug 'ctrlpvim/ctrlp.vim'
    let g:ctrlp_working_path_mode = ''

    Plug 'vim-scripts/scratch.vim'

    Plug 'troydm/easybuffer.vim'
    nmap <leader>be :EasyBufferToggle<cr>

    Plug 'mg979/vim-visual-multi'

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
endif
" }}}

" _. Fancy {{{
if count(g:vimified_packages, 'fancy')
    "call g:Check_defined('g:airline_left_sep', '')
    "call g:Check_defined('g:airline_right_sep', '')
    "call g:Check_defined('g:airline_branch_prefix', '')

    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
endif
" }}}

" _. Indent {{{
if count(g:vimified_packages, 'indent')
  Plug 'Yggdroot/indentLine'
  set list lcs=tab:\|\
  let g:indentLine_color_term = 111
  let g:indentLine_color_gui = '#DADADA'
  let g:indentLine_char = 'c'
  "let g:indentLine_char = '∙▹¦'
  let g:indentLine_char = '∙'
endif
" }}}

" _. Coding {{{

if count(g:vimified_packages, 'coding')
    Plug 'majutsushi/tagbar'
    nmap <leader>t :TagbarToggle<CR>

    Plug 'scrooloose/nerdcommenter'
    nmap <leader># :call NERDComment(0, "invert")<cr>
    vmap <leader># :call NERDComment(0, "invert")<cr>

    Plug 'sjl/splice.vim'

    Plug 'tpope/vim-fugitive'
    nmap <leader>gs :Gstatus<CR>
    nmap <leader>gc :Gcommit -v<CR>
    nmap <leader>gac :Gcommit --amen -v<CR>
    nmap <leader>g :Ggrep
    " ,f for global git search for word under the cursor (with highlight)
    nmap <leader>f :let @/="\\<<C-R><C-W>\\>"<CR>:set hls<CR>:silent Ggrep -w "<C-R><C-W>"<CR>:ccl<CR>:cw<CR><CR>
    " same in visual mode
    :vmap <leader>f y:let @/=escape(@", '\\[]$^*.')<CR>:set hls<CR>:silent Ggrep -F "<C-R>=escape(@", '\\"#')<CR>"<CR>:ccl<CR>:cw<CR><CR>

    Plug 'scrooloose/syntastic'
    let g:syntastic_enable_signs=1
    let g:syntastic_auto_loc_list=1
    let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': ['ruby', 'python', ], 'passive_filetypes': ['html', 'css', 'slim'] }

    " --

    Plug 'vim-scripts/Reindent'

    autocmd FileType gitcommit set tw=68 spell
    autocmd FileType gitcommit setlocal foldmethod=manual

    " Check API docs for current word in Zeal: http://zealdocs.org/
    nnoremap <leader>d :!zeal --query "<cword>"&<CR><CR>

    Plug 'Townk/vim-autoclose'

    Plug 'sheerun/vim-polyglot'
endif
" }}}

" _. HTML {{{
    au BufNewFile,BufReadPost *.html setl shiftwidth=2 tabstop=2 softtabstop=2 expandtab
" }}}

" _. JS {{{
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
" }}}

" _. Markdown {{{
    au BufNewFile,BufReadPost *.md set filetype=markdown
if count(g:vimified_packages, 'markdown')
    Plug 'tpope/vim-markdown'
    let g:markdown_fenced_languages = ['coffee', 'css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml', 'html']
endif
" }}}

" _. Color {{{
  if filereadable(globpath(&rtp, 'colors/solarized.vim'))
    set background=dark
		colorscheme solarized
		let g:solarized_termtrans=1
  else
    colorscheme default
  endif
" }}}

" Initialize plugin system
call plug#end()
" }}}

" General {{{
filetype plugin indent on

" Enable syntax highlighting
syntax on

" Start scrolling three lines before the horizontal window border
set scrolloff=3

" It defines where to look for the buffer user demanding (current window, all
" windows in other tabs, or nowhere, i.e. open file from scratch every time) and
" how to open the buffer (in the new split, tab, or in the current window).

" This orders Vim to open the buffer.
set switchbuf=useopen

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" }}}

" Mappings {{{

" You want to be part of the gurus? Time to get in serious stuff and stop using
" arrow keys.
"noremap <left> <nop>
"noremap <up> <nop>
"noremap <down> <nop>
"noremap <right> <nop>

" Yank from current cursor position to end of line
map Y y$
" Yank content in OS's clipboard. `o` stands for "OS's Clipoard".
vnoremap <leader>yo "*y
" Paste content from OS's clipboard
nnoremap <leader>po "*p

" clear highlight after search
noremap <silent><Leader>/ :nohls<CR>

" better ESC
inoremap <C-k> <Esc>

nmap <silent> <leader>hh :set invhlsearch<CR>
nmap <silent> <leader>ll :set invlist<CR>
nmap <silent> <leader>nn :set invnumber<CR>
nmap <silent> <leader>pp :set invpaste<CR>
nmap <silent> <leader>ii :set invrelativenumber<CR>

" Seriously, guys. It's not like :W is bound to anything anyway.
command! W :w

" Emacs bindings in command line mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Source current line
vnoremap <leader>L y:execute @@<cr>
" Source visual selection
nnoremap <leader>L ^vg_y:execute @@<cr>

" Fast saving and closing current buffer without closing windows displaying the
" buffer
nmap <leader>wq :w!<cr>:Bclose<cr>

" }}}

" . abbrevs {{{
"
iabbrev z@ oh@zaiste.net

" . }}}

" Settings {{{
set autoread
" Allow backspace in insert mode
set backspace=indent,eol,start
" Don’t add empty newlines at the end of files
set binary
set cinoptions=:0,(s,u0,U1,g0,t0
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Allow cursor keys in insert mode
set esckeys
set hidden
set history=1000
" Always show status line
set laststatus=2
set list
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Optimize for fast terminal connections
set ttyfast
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Don't redraw while executing macros
set nolazyredraw
" Disable the macvim toolbar
set guioptions-=T

" Show “invisible” characters
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:·,nbsp:␣
set showbreak=↪

set notimeout
set ttimeout
set ttimeoutlen=10

" _ backups {{{
if has('persistent_undo')
  " undo files
  exec 'set undodir='.s:dotvim.'/tmp/undo//'
  set undofile
  set undolevels=3000
  set undoreload=10000
endif
" backups
exec 'set backupdir='.s:dotvim.'/tmp/backup//'
" swap files
exec 'set directory='.s:dotvim.'/tmp/swap//'
set backup
set noswapfile
" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*
" _ }}}

" Respect modeline in files
set modeline
set modelines=4

set noeol
if exists('+number')
  set number
	au BufReadPost * set number
endif
set numberwidth=3
set winwidth=83
" Show the cursor position
set ruler
if executable('zsh')
  set shell=zsh\ -l
endif
" Show the (partial) command as it’s being typed
set showcmd

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

set matchtime=2

set completeopt=longest,menuone,preview

" White characters {{{
set autoindent
set tabstop=2
set softtabstop=4
set textwidth=80
set shiftwidth=4
set expandtab
set wrap
set formatoptions=qrn1
set cpo+=J
" }}}

" Enhance command-line completion

set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,.DS_Store,*.aux,*.out,*.toc,tmp,*.scssc
set wildmenu

set dictionary=/usr/share/dict/words
" }}}

" Triggers {{{

" Save when losing focus
au FocusLost    * :silent! wall
"
" When vimrc is edited, reload it
autocmd! BufWritePost vimrc source $MYVIMRC

" }}}

" Cursorline {{{
" Only show cursorline in the current window and in normal/insert mode.
augroup cline
    au!
    set cursorline
    au WinLeave * set nocursorline
    au WinEnter * set cursorline
    au InsertEnter * set cursorline
    au InsertLeave * set cursorline
augroup END

" Set cursor shape in insert mode
let &t_SI = "\<Esc>[5 q"
let &t_EI = "\<Esc>[1 q"

" }}}

" Trailing whitespace {{{
" Only shown when not in insert mode so I don't go insane.
augroup trailing
    au!
    au InsertEnter * :set listchars-=trail:␣
    au InsertLeave * :set listchars+=trail:␣
augroup END

" Remove trailing whitespaces when saving
" Wanna know more? http://vim.wikia.com/wiki/Remove_unwanted_spaces
" If you want to remove trailing spaces when you want, so not automatically,
" see
" http://vim.wikia.com/wiki/Remove_unwanted_spaces#Display_or_remove_unwanted_whitespace_with_a_script.
autocmd BufWritePre * :%s/\s\+$//e

" }}}

" . searching {{{

" sane regexes
nnoremap / /\v
vnoremap / /\v

" Ignore case of searches
set ignorecase
set smartcase
set showmatch
" Add the g flag to search/replace by default
set gdefault
" Highlight searches
set hlsearch
" Highlight dynamically as pattern is typed
set incsearch

" clear search matching
noremap <leader><space> :noh<cr>:call clearmatches()<cr>

" Don't jump when using * for search
nnoremap * *<c-o>

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz

" Open a Quickfix window for the last search.
nnoremap <silent> <leader>? :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Highlight word {{{

nnoremap <silent> <leader>hh :execute 'match InterestingWord1 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h1 :execute 'match InterestingWord1 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h2 :execute '2match InterestingWord2 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h3 :execute '3match InterestingWord3 /\<<c-r><c-w>\>/'<cr>

" }}}

" }}}

" Navigation & UI {{{

" more natural movement with wrap on
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Easy splitted window navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l

" Easy buffer navigation
noremap <leader>bp :bprevious<cr>
noremap <leader>bn :bnext<cr>

" Splits ,v and ,h to open new splits (vertical and horizontal)
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>h <C-w>s<C-w>j

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" Bubbling lines
nmap <C-Up> [e
nmap <C-Down> ]e
vmap <C-Up> [egv
vmap <C-Down> ]egv

" }}}

" . folding {{{

set foldlevelstart=0
set foldmethod=syntax
set foldnestmax=10
set nofoldenable
set foldlevel=0

" Space to toggle folds.
nnoremap <space> za
vnoremap <space> za

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO

" Use ,z to "focus" the current fold.
nnoremap <leader>z zMzvzz

" }}}

" Quick editing {{{

nnoremap <leader>ev <C-w>s<C-w>j:e $MYVIMRC<cr>
exec 'nnoremap <leader>es <C-w>s<C-w>j:e '.s:dotvim.'/snippets/<cr>'
nnoremap <leader>eg <C-w>s<C-w>j:e ~/.gitconfig<cr>
nnoremap <leader>ez <C-w>s<C-w>j:e ~/.zshrc<cr>
nnoremap <leader>et <C-w>s<C-w>j:e ~/.tmux.conf<cr>

" --------------------

set ofu=syntaxcomplete#Complete
let g:rubycomplete_buffer_loading = 0
let g:rubycomplete_classes_in_global = 1

" showmarks
let g:showmarks_enable = 1
hi! link ShowMarksHLl LineNr
hi! link ShowMarksHLu LineNr
hi! link ShowMarksHLo LineNr
hi! link ShowMarksHLm LineNr

" }}}

" _ Vim {{{
augroup ft_vim
    au!

    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=78
    au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END
" }}}

" EXTENSIONS {{{

" _. Scratch {{{
exec ':so '.s:dotvim.'/functions/scratch_toggle.vim'
" }}}

" _. Buffer Handling {{{
exec ':so '.s:dotvim.'/functions/buffer_handling.vim'
" }}}

" _. Tab {{{
exec ':so '.s:dotvim.'/functions/insert_tab_wrapper.vim'
" }}}

" _. Text Folding {{{
exec ':so '.s:dotvim.'/functions/my_fold_text.vim'
" }}}


" }}}

" Load addidional configuration (ie to overwrite shorcuts) {{{
let s:afterrc = expand(s:dotvim . '/after.vimrc')
if filereadable(s:afterrc)
    exec ':so ' . s:afterrc
endif
" }}}
