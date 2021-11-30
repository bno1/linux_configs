set nocompatible
set termguicolors

syntax on
filetype on
filetype plugin on
filetype plugin indent on
set encoding=utf-8

colorscheme desert

set signcolumn=number
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

if has('pythonx')
    set pyx=3
endif

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
call plug#begin(stdpath('data') . '/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-syntastic/syntastic'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/vim-easy-align'
Plug 'embear/vim-localvimrc'
"Plug 'jeetsukumaran/vim-buffergator'

Plug 'solarnz/thrift.vim', {'for': 'thrift'}
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'rust-lang/rust.vim'
Plug 'thaerkh/vim-indentguides'
"Plug 'junegunn/fzf'
"Plug 'junegunn/fzf.vim'
"Plug 'liuchengxu/vista.vim'
Plug 'kevinoid/vim-jsonc'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"Plug 'neovim/nvim-lspconfig'
"Plug 'hrsh7th/nvim-compe'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
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
" let g:vista_default_executive = 'coc'
" let g:vista_fzf_preview = ['right:50%']
" let g:vista_stay_on_open = 0
" 
" " Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
" let g:vista#renderer#enable_icon = 0
" 
" nmap <F8> :Vista<CR>


""""""""""
" vim-go "
""""""""""
let g:go_gopls_enabled = 0


"""""""""""""""""""
" nvim-treesitter "
"""""""""""""""""""
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { },  -- list of language that will be disabled
  },
  incremental_selection = {
    enable = true,
  },
  indent = {
    enable = false,
  },
}
EOF


""""""""""""""""""
" nvim-lspconfig "
""""""""""""""""""
" lua << EOF
" require'lspconfig'.pyright.setup{}
" require'lspconfig'.tsserver.setup{}
" 
" local nvim_lsp = require('lspconfig')
" local on_attach = function(_client, bufnr)
"   vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
" 
"   local opts = { noremap=true, silent=true }
"   -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
"   -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gt', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
"   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>k', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
"   -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
"   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
"   -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
"   -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
"   -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
"   -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
"   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
"   -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gf', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
"   -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
"   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
"   vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
"   vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
"   -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
" end
" 
" -- Enable the following language servers
" local servers = { 'pyright', 'tsserver' }
" for _, lsp in ipairs(servers) do
"   nvim_lsp[lsp].setup { on_attach = on_attach }
" end
" EOF


""""""""""""""
" nvim-compe "
""""""""""""""
" lua << EOF
" require'compe'.setup {
"   enabled = true;
"   autocomplete = true;
"   debug = false;
"   min_length = 1;
"   preselect = 'enable';
"   throttle_time = 80;
"   source_timeout = 200;
"   resolve_timeout = 800;
"   incomplete_delay = 400;
"   max_abbr_width = 100;
"   max_kind_width = 100;
"   max_menu_width = 100;
"   documentation = {
"     border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
"     winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
"     max_width = 120,
"     min_width = 60,
"     max_height = math.floor(vim.o.lines * 0.3),
"     min_height = 1,
"   };
" 
"   source = {
"     path = true;
"     buffer = true;
"     calc = true;
"     nvim_lsp = true;
"     nvim_lua = true;
"   };
" }
" 
" local t = function(str)
"   return vim.api.nvim_replace_termcodes(str, true, true, true)
" end
" 
" local check_back_space = function()
"     local col = vim.fn.col('.') - 1
"     return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
" end
" 
" -- Use (s-)tab to:
" --- move to prev/next item in completion menuone
" --- jump to prev/next snippet's placeholder
" _G.tab_complete = function()
"   if vim.fn.pumvisible() == 1 then
"     return t "<C-n>"
"   elseif check_back_space() then
"     return t "<Tab>"
"   else
"     return vim.fn['compe#complete']()
"   end
" end
" _G.s_tab_complete = function()
"   if vim.fn.pumvisible() == 1 then
"     return t "<C-p>"
"   else
"     -- If <S-Tab> is not working in your terminal, change it to <C-h>
"     return t "<S-Tab>"
"   end
" end
" 
" vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
" vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
" vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
" vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
" EOF
" 
" inoremap <silent><expr> <C-Space> compe#complete()
" inoremap <silent><expr> <CR>      compe#confirm('<CR>')
" inoremap <silent><expr> <C-e>     compe#close('<C-e>')
" inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
" inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })


""""""""""""""""""
" telescope.nvim "
""""""""""""""""""
lua << EOF
local actions = require('telescope.actions')

require('telescope').setup{
    defaults = {
        file_ignore_patterns = { "%.git/.*", "node%_modules/.*" },
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
        },
    },
}
EOF

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
" nnoremap <leader>gf <cmd>Telescope lsp_references<cr>
" nnoremap <leader>gt <cmd>Telescope lsp_definitions<cr>
" nnoremap <leader>gy <cmd>Telescope lsp_implementations<cr>
" nnoremap <leader>a <cmd>Telescope lsp_code_actions<cr>
