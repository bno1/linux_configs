vim.cmd [[
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
    " set textwidth=80
    set nofixendofline
    set updatetime=300

    if has("pythonx")
        set pyx=3
    endif

    if has("gui_running")
        set guifont=Monospace\ 8
    endif

    set list
    set listchars=tab:»\ ,extends:»,precedes:«,trail:·
    set statusline=%<%f\ %y%h%m%r%=%{FugitiveStatusline()}\ %-24.(%o\ %l/%L\ %c%V%)\ %P
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
    nnoremap <C-k> :cn<CR>
    nnoremap <C-j> :cp<CR>

    " <Ctrl-l> redraws the screen and removes any search highlighting.
    nnoremap <silent> <C-l> :nohl<CR><C-l>

    au BufNewFile,BufRead *.tex set filetype=tex
]]

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',

    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

    'junegunn/vim-easy-align',
    'embear/vim-localvimrc',
    'lukas-reineke/indent-blankline.nvim',

    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/nvim-cmp',

    { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
    'saadparwaiz1/cmp_luasnip',

    'jose-elias-alvarez/null-ls.nvim',

    'nvim-telescope/telescope.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-telescope/telescope-ui-select.nvim',

    'folke/neodev.nvim',
    { 'lervag/vimtex', ft = 'tex'},
    { 'fatih/vim-go', build = ':GoUpdateBinaries' },

    'tpope/vim-fugitive',
    'ggandor/leap.nvim',
})

---------------
-- EasyAlign --
---------------
vim.cmd [[
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign

    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    xmap ga <Plug>(EasyAlign

    " / align for C++ comments
    let g:easy_align_delimiters = {
    \ '/': {
    \     'pattern':         '//\+\|/\*\|\*/',
    \     'delimiter_align': 'l',
    \     'ignore_groups':   ['!Comment']
    \   }
    \ }
]]

------------
-- vim-go --
------------
vim.cmd [[ let g:go_gopls_enabled = 0 ]]

---------
-- LSP --
---------
local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local neodev = require('neodev')
local cmp = require('cmp')
local lspconfig = require('lspconfig')
local luasnip = require('luasnip')
local null_ls = require('null-ls')

neodev.setup {}

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
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
            { name = 'nvim_lsp_signature_help' },
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

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', '<leader>gd', vim.lsp.buf.declaration, opts)
        --vim.keymap.set('n', '<leader>gt', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, opts)
        --vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        --vim.keymap.set('n', '<leader>gy', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)
        --vim.keymap.set('n', '<leader>gf', vim.lsp.buf.references, opts)
        vim.keymap.set({'n', 'v'}, '<leader>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local base_config = {
    capabilities = capabilities,
    on_attach = function(client)
        -- use eslint via null-ls for formatting instead
        if client.name == 'tsserver' then
            client.server_capabilities.documentFormattingProvider = false
        end
    end,
}

local servers = {
    pyright = {},
    tsserver = {},
    bashls = {},
    lua_ls = {},
    clangd = {
        cmd = {
            'clangd', '--background-index', '--clang-tidy',
            '--header-insertion=never', '--suggest-missing-includes',
            '--completion-style=detailed'
        },
    },
}

for lsp, lsp_config in pairs(servers) do
    local config = vim.tbl_deep_extend('force', base_config, lsp_config)
    lspconfig[lsp].setup(config)
end

null_ls.setup {
    sources = {
        -- bash
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.diagnostics.shellcheck,

        -- js/ts
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.formatting.eslint_d,

        -- c/cpp
        null_ls.builtins.diagnostics.clang_check,
        null_ls.builtins.formatting.clang_format,

        -- python
        null_ls.builtins.diagnostics.mypy,
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.pylint,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.black,
    },
}

---------------------
-- nvim-treesitter --
---------------------
-- Note: has to be after LSP
-- See:
--   - https://neovim.discourse.group/t/lsp-not-starting-automatically/1886/9
--   - https://github.com/wbthomason/packer.nvim/issues/778
require'nvim-treesitter.configs'.setup {
  ensure_installed = {'c', 'cpp', 'bash', 'python', 'typescript', 'javascript',
                      'html', 'cmake', 'dockerfile', 'go', 'haskell', 'java',
                      'json', 'latex', 'lua', 'make', 'toml', 'yaml', 'tsx'},
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { },  -- list of language that will be disabled
  },
  incremental_selection = {
    enable = false,
  },
  indent = {
    enable = false,
  },
}

--------------------
-- telescope.nvim --
--------------------
local telescope = require('telescope');
local telescope_actions = require('telescope.actions');

telescope.load_extension('fzf')
telescope.load_extension('ui-select')

telescope.setup{
    defaults = {
        file_ignore_patterns = { '%.git\\', 'node%_modules\\', '%.cache\\', '%.obj$', '%.tlog$' },
        mappings = {
            i = {
                ["<esc>"] = telescope_actions.close,
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
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown()
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

---------------------------
-- indent-blankline.nvim --
---------------------------
vim.cmd [[
    highlight IndentBlanklineChar guifg=#4C4C4C gui=nocombine
]]

require('indent_blankline').setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = false,
    char = '┆',
}

---------------
-- leap.nvim --
---------------
require('leap').add_default_mappings()

----------------
-- localvimrc --
----------------
vim.cmd [[
    let g:localvimrc_sandbox = 0
    let g:localvimrc_whitelist = [
    \ ]
]]
