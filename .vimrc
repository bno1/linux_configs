set nocompatible
set termguicolors

syntax on
filetype on
filetype plugin on
filetype plugin indent on
set encoding=utf-8

colorscheme desert

set signcolumn=auto
set tabstop=4
set shiftwidth=4
set softtabstop=4
set colorcolumn=80
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
set completeopt=longest,menuone,noselect
"set textwidth=80
set nofixendofline
set updatetime=300

if has('gui_running')
    set guifont=Monospace\ 8
endif

hi Pmenu ctermbg=darkgray guibg=#0f0f0f
hi PmenuSel ctermbg=lightgray guibg=#303030

set list
set listchars=tab:»\ ,extends:»,precedes:«,trail:·
set statusline=%<%f\ %y%h%m%r\ %{coc#status()}\ %{get(b:,'coc_current_function','')}%=%-24.(%o\ %l/%L\ %c%V%)\ %P
set laststatus=2
set wildmenu
set wildmode=longest,list

let maplocalleader = "\\"
let no_ocaml_maps=1

nnoremap <C-Up> <c-w>k
nnoremap <C-Down> <c-w>j
nnoremap <C-Left> <c-w>h
nnoremap <C-Right> <c-w>l
nnoremap <ESC>+ <c-w>+
nnoremap <ESC>- <c-w>-
nnoremap <ESC>/ <c-w><
nnoremap <ESC>* <c-w>>
nnoremap <C-k> :cn<CR>
nnoremap <C-j> :cp<CR>

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

au BufNewFile,BufRead *.tex set filetype=tex

runtime autoload/vim-plug/plug.vim
call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-syntastic/syntastic'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/vim-easy-align'
Plug 'embear/vim-localvimrc'
Plug 'jeetsukumaran/vim-buffergator'

Plug 'solarnz/thrift.vim', {'for': 'thrift'}
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'rust-lang/rust.vim'
Plug 'Yggdroot/indentLine'
"Plug 'thaerkh/vim-indentguides'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vista.vim'
Plug 'kevinoid/vim-jsonc'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'tikhomirov/vim-glsl'

" Initialize plugin system
call plug#end()

"""""""""
" CtrlP "
"""""""""

let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/](\.(git|hg|svn))|node_modules$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

"""""""
" CoC "
"""""""

autocmd CursorHold * silent call CocActionAsync('highlight')
nnoremap <F5> <Plug>(coc-codeaction)
nmap <leader>gt <Plug>(coc-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gd <Plug>(coc-declaration)
nmap <leader>gf <Plug>(coc-references)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>a <Plug>(coc-codeaction)
nmap <leader>F <Plug>(coc-format)
nmap <leader>f <Plug>(coc-format-selected)
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>k :call CocAction('doHover')<CR>
nmap <leader>rn <Plug>(coc-rename)

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

set completeopt=menuone,preview


"""""""""""""
" Syntastic "
"""""""""""""
" Use passive mode for haskell
let g:syntastic_mode_map = {
    \ "mode": "active",
    \ "passive_filetypes": ["haskell"] }

let g:syntastic_python_checkers = []
let g:syntastic_ocaml_checkers = ['merlin']
let g:syntastic_c_checkers = []
let g:syntastic_cpp_checkers = []
let g:syntastic_rust_checkers = []
let g:syntastic_javascript_checkers = ['eslint']


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


"""""""""
" Vista "
"""""""""
let g:vista_default_executive = 'coc'
let g:vista_fzf_preview = ['right:50%']
let g:vista_stay_on_open = 0

" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 0

nmap <F8> :Vista<CR>


""""""""""
" vim-go "
""""""""""
let g:go_gopls_enabled = 0


""""""""""""""
" indentLine "
""""""""""""""

let g:indentLine_char = '┆'


""""""""""""""
" localvimrc "
""""""""""""""
let g:localvimrc_sandbox = 0
let g:localvimrc_whitelist = [
\ ]
