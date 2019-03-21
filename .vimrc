set nocompatible

syntax on
filetype on
filetype plugin on
set encoding=utf-8

colorscheme desert

set tabstop=4
set shiftwidth=4
set softtabstop=4
set colorcolumn=81
set smartindent
set autoindent
set expandtab
set noshowmatch
set showcmd
set incsearch
set hlsearch
set smartcase
set backspace=2
set backspace=indent,eol,start
set nu
set completeopt=longest,menuone
"set textwidth=80

if has('gui_running')
    set guifont=Monospace\ 8
endif

set list
set listchars=tab:»\ ,extends:»,precedes:«,trail:·
set statusline=%<%f\ %y%h%m%r%=%-24.(%o\ %l/%L\ %c%V%)\ %P
set laststatus=2
set wildmenu
set wildmode=longest,list

nnoremap <C-Up> <c-w>k
nnoremap <C-Down> <c-w>j
nnoremap <C-Left> <c-w>h
nnoremap <C-Right> <c-w>l
nnoremap <ESC>+ <c-w>+
nnoremap <ESC>- <c-w>-
nnoremap <ESC>/ <c-w><
nnoremap <ESC>* <c-w>>

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

autocmd FileType haskell setlocal et
autocmd FileType cabal setlocal et
autocmd FileType sql setlocal et
au BufNewFile,BufRead *.tex set filetype=tex

runtime autoload/vim-plug/plug.vim
call plug#begin('~/.vim/plugged')

Plug 'vim-syntastic/syntastic'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/vim-easy-align'
Plug 'embear/vim-localvimrc'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --system-boost --system-libclang --ninja'}

Plug 'solarnz/thrift.vim', {'for': 'thrift'}
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'eagletmt/neco-ghc', {'for': 'haskell'}
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'racer-rust/vim-racer'
Plug 'rust-lang/rust.vim'

" Initialize plugin system
call plug#end()

"""""""""""""
" Syntastic "
"""""""""""""
" Use passive mode for haskell
let g:syntastic_mode_map = {
    \ "mode": "active",
    \ "passive_filetypes": ["haskell"] }

let g:syntastic_python_checkers = ['python', 'flake8']

"""""""""""""
" EasyAlign "
"""""""""""""
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" / align for C++ comments
let g:easy_align_delimiters = {
\ '/': {
\     'pattern':         '//\+\|/\*\|\*/',
\     'delimiter_align': 'l',
\     'ignore_groups':   ['!Comment']
\   }
\ }


""""""""""
" GhcMod "
""""""""""
" Lint on write
" autocmd BufWritePost *.hs GhcModCheckAndLintAsync

"""""""""""
" NecoGhc "
"""""""""""
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc


"""""""
" YCM "
"""""""
let g:ycm_semantic_triggers = {'haskell' : ['.']}

let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0

nnoremap <leader>jd :YcmCompleter GoTo<CR>
