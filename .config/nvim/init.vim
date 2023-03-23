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
set completeopt=menu,menuone,noselect,preview
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
set statusline=%<%f\ %y%h%m%r%=%{FugitiveStatusline()}\ %-24.(%o\ %l/%L\ %c%V%)\ %P
set laststatus=2
set wildmenu
set wildmode=longest,list

let maplocalleader = "\\"
let no_ocaml_maps=1
let g:vimsyn_embed = 'l'

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

lua <<EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- { 'neoclide/coc.nvim', branch = 'release'},
    'vim-syntastic/syntastic',
    -- 'ctrlpvim/ctrlp.vim',
    'junegunn/vim-easy-align',
    'embear/vim-localvimrc',
    -- 'jeetsukumaran/vim-buffergator',
    { 'lervag/vimtex', ft = 'tex'},
    { 'fatih/vim-go', build = ':GoUpdateBinaries' },
    --'rust-lang/rust.vim',
    'lukas-reineke/indent-blankline.nvim',
    -- 'thaerkh/vim-indentguides'
    -- 'junegunn/fzf'
    -- 'junegunn/fzf.vim'
    -- 'liuchengxu/vista.vim'
    -- 'leafgarland/typescript-vim',
    -- 'peitalin/vim-jsx-typescript'
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
    'saadparwaiz1/cmp_luasnip',
    'ray-x/lsp_signature.nvim',
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    -- 'fannheyward/telescope-coc.nvim',
    'tpope/vim-fugitive',
})
EOF

"runtime autoload/vim-plug/plug.vim
"call plug#begin(stdpath('data') . '/plugged')

"   Plug 'neoclide/coc.nvim', {'branch': 'release'}
"   Plug 'vim-sy90ggntastic/syntastic'
"   "Plug 'ctrlpvim/ctrlp.vim'
"   Plug 'junegunn/vim-easy-align'
"   Plug 'embear/vim-localvimrc'
"   "Plug 'jeetsukumaran/vim-buffergator'
"   Plug 'solarnz/thrift.vim', {'for': 'thrift'}
"   Plug 'lervag/vimtex', {'for': 'tex'}
"   Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
"   Plug 'rust-lang/rust.vim'
"   Plug 'lukas-reineke/indent-blankline.nvim'
"   "Plug 'thaerkh/vim-indentguides'
"   "Plug 'junegunn/fzf'
"   "Plug 'junegunn/fzf.vim'
"   "Plug 'liuchengxu/vista.vim'
"   Plug 'kevinoid/vim-jsonc'
"   Plug 'leafgarland/typescript-vim'
"   Plug 'peitalin/vim-jsx-typescript'
"   Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"   "Plug 'neovim/nvim-lspconfig'
"   "Plug 'hrsh7th/nvim-compe'
"   Plug 'nvim-lua/popup.nvim'
"   Plug 'nvim-lua/plenary.nvim'
"   Plug 'nvim-telescope/telescope.nvim'
"   Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
"   Plug 'fannheyward/telescope-coc.nvim'
"   Plug 'tikhomirov/vim-glsl'
"   Plug 'tpope/vim-fugitive'

" Initialize plugin system
"call plug#end()

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

" autocmd CursorHold * silent call CocActionAsync('highlight')
" nnoremap <F5> <Plug>(coc-codeaction)
" " nmap <leader>gt <Plug>(coc-definition)
" " nmap <leader>gi <Plug>(coc-implementation)
" " nmap <leader>gd <Plug>(coc-declaration)
" " nmap <leader>gf <Plug>(coc-references)
" " nmap <leader>gy <Plug>(coc-type-definition)
" nmap <leader>a <Plug>(coc-codeaction)
" nmap <leader>F <Plug>(coc-format)
" nmap <leader>f <Plug>(coc-format-selected)
" xmap <leader>f <Plug>(coc-format-selected)
" nmap <leader>k :call CocAction('doHover')<CR>
" nmap <leader>rn <Plug>(coc-rename)
" 
" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
" 
" inoremap <silent><expr> <TAB>
"   \ coc#pum#visible() ? coc#_select_confirm() :
"   \ coc#expandableOrJumpable() ?
"   \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"   \ <SID>check_back_space() ? "\<TAB>" :
"   \ coc#refresh()
" 
" inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"
" 
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction
" 
" let g:coc_snippet_next = '<tab>'
" 
" set completeopt=menuone,preview


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
  ensure_installed = {'c', 'cpp', 'bash', 'python', 'typescript', 'javascript',
                      'html', 'cmake', 'dockerfile', 'go', 'haskell', 'java',
                      'json', 'latex', 'lua', 'make', 'toml', 'yaml', 'tsx'},
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
lua << EOF
local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require('cmp')
local lspconfig = require('lspconfig')
local luasnip = require('luasnip')
local lsp_signature = require('lsp_signature')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
            -- they way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            -- { name = 'vsnip' }, -- For vsnip users.
            { name = 'luasnip' }, -- For luasnip users.
            -- { name = 'ultisnips' }, -- For ultisnips users.
            -- { name = 'snippy' }, -- For snippy users.
        }, {
        { name = 'buffer' },
        { name = 'path' },
    }),
    experimental = {
        ghost_text = true,
    },
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_m      ghost_text = true,enu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { 'pyright', 'tsserver', 'bashls' }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        capabilities = capabilities,
    }
end

lspconfig.clangd.setup {
    capabilities = capabilities,
    cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=never', '--suggest-missing-includes', '--completion-style=detailed' },
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        lsp_signature.on_attach({
            bind = true,
            handler_opts = {
                border = "none",
            },
        }, ev.bufnr)

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', '<leader>gd', vim.lsp.buf.declaration, opts)
        --vim.keymap.set('n', '<leader>gt', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, opts)
        --vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        --vim.keymap.set('n', '<leader>gy', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)
        --vim.keymap.set('n', '<leader>gf', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>F', function()
            vim.lsp.buf.format { async = true }
        end, opts)
        vim.keymap.set('n', '<leader>F', function()
            vim.lsp.buf.format {
                async = true,
                range = {
                    ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
                    ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
                },
            }
        end, opts)
    end,
})
EOF


""""""""""""""""""
" telescope.nvim "
""""""""""""""""""
lua << EOF
local telescope = require('telescope');
local actions = require('telescope.actions');

-- telescope.load_extension('coc')
telescope.load_extension('fzf')

telescope.setup{
    defaults = {
        file_ignore_patterns = { '%.git\\', 'node%_modules\\', '%.cache\\', '%.obj$', '%.tlog$' },
        mappings = {
            i = {
                ["<esc>"] = actions.close,
                ["<C-u>"] = false,
            },
        },
        layout_strategy = 'vertical',
    },
    pickers = {
        buffers = {
            theme = 'dropdown',
        },
        code_actions = {
            theme = 'cursor',
        },
    },
}

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>gf', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>gt', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>gi', builtin.lsp_implementations, {})
vim.keymap.set('n', '<leader>gy', builtin.lsp_type_definitions, {})
vim.keymap.set('n', '<leader>s', builtin.lsp_document_symbols, {})
--vim.keymap.set('n', '<leader>a', builtin.lsp_code_actions, {})
EOF

" Find files using Telescope command-line sugar.
"nnoremap <leader>ff <cmd>Telescope find_files<cr>
"nnoremap <leader>fg <cmd>Telescope live_grep<cr>
"nnoremap <leader>b <cmd>Telescope buffers theme=dropdown<cr>
"nnoremap <leader>fh <cmd>Telescope help_tags<cr>
"nnoremap <leader>gf <cmd>Telescope coc references<cr>
"nnoremap <leader>gt <cmd>Telescope coc definitions<cr>
"nnoremap <leader>gy <cmd>Telescope coc implementations<cr>
"nnoremap <leader>s <cmd>Telescope coc document_symbols<cr>
"nnoremap <leader>a <cmd>Telescope coc code_actions theme=cursor<cr>


"""""""""""""""""""""""""
" indent-blankline.nvim "
"""""""""""""""""""""""""

highlight IndentBlanklineChar guifg=#4C4C4C gui=nocombine

lua << EOF
require('indent_blankline').setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = false,
    char = '┆',
}
EOF
