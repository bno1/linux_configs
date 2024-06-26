vim.cmd([[
    set nocompatible
    set termguicolors

    syntax on
    filetype on
    filetype plugin on
    filetype plugin indent on
    set encoding=utf-8

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
    set cursorline
    set smartcase
    set backspace=2
    set backspace=indent,eol,start
    set nu
    set completeopt=menu,menuone,noselect,noinsert,preview
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
    set listchars=tab:¦\ ,extends:»,precedes:«,trail:·
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
    nmap <PageUp> <C-B>
    nmap <PageDown> <C-F>

    " <Ctrl-l> redraws the screen and removes any search highlighting.
    nnoremap <silent> <C-l> :nohl<CR><C-l>

    au BufNewFile,BufRead *.tex set filetype=tex
]])

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

local keymap = vim.keymap

require("lazy").setup({
	"lbrayner/vim-rzip",

	"EdenEast/nightfox.nvim",

	-- {
	-- 	"nvim-lua/popup.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- }, -- TODO dep

	"lewis6991/gitsigns.nvim",

	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

	"junegunn/vim-easy-align",
	"embear/vim-localvimrc",
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl" },
	{ "L3MON4D3/LuaSnip", build = "make install_jsregexp" },

	"neovim/nvim-lspconfig",
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
		},
	},
	{
		"saadparwaiz1/cmp_luasnip",
		dependencies = { "L3MON4D3/LuaSnip", "hrsh7th/nvim-cmp" },
	},

	{
		"folke/lazydev.nvim",
	},

	{
		"SmiteshP/nvim-navbuddy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
		},
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	"ray-x/lsp_signature.nvim",
	"RRethy/vim-illuminate",

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"nvim-treesitter/nvim-treesitter",
		},
	},

	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	"nvim-telescope/telescope-ui-select.nvim",

	{ "lervag/vimtex", ft = "tex" },

	"tpope/vim-fugitive",
	"phaazon/hop.nvim",
	"karb94/neoscroll.nvim",

	{
		"freddiehaddad/feline.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"lewis6991/gitsigns.nvim",
		},
	},
})

------------------
-- Color Scheme --
------------------
vim.cmd([[
    colorscheme nightfox
]])

-----------------------
-- nvim-web-devicons --
-----------------------
require("nvim-web-devicons").setup({})

--------------
-- gitsigns --
--------------
require("gitsigns").setup({})

---------------
-- EasyAlign --
---------------
vim.cmd([[
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
]])

---------
-- LSP --
---------
local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")
local lspconfig = require("lspconfig")
local lsputil = require("lspconfig.util")
local navic = require("nvim-navic")
local navbuddy = require("nvim-navbuddy")
local lsp_signature = require("lsp_signature")
local luasnip = require("luasnip")
local null_ls = require("null-ls")

cmp.setup({
	preselect = cmp.PreselectMode.None,
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
		{ name = "nvim_lsp" },
		-- { name = 'vsnip' }, -- For vsnip users.
		{ name = "luasnip" }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
		-- { name = 'nvim_lsp_signature_help' },
		{ name = "lazydev" },
	}, {
		{ name = "buffer" },
		{ name = "path" },
	}),
	experimental = {
		ghost_text = true,
	},
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_m      ghost_text = true,enu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
keymap.set("n", "<space>e", vim.diagnostic.open_float)
keymap.set("n", "[d", vim.diagnostic.goto_prev)
keymap.set("n", "]d", vim.diagnostic.goto_next)
keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local bufnr = ev.buf
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		if client.server_capabilities.documentSymbolProvider then
			navic.attach(client, bufnr)
			navbuddy.attach(client, bufnr)
		end

		if client.name == "tsserver" then
			-- use eslint via null-ls for formatting instead
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		elseif client.name == "lua_ls" then
			-- use stylua via null-ls for formatting instead
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end

		-- Enable completion triggered by <c-x><c-o>
		vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

		lsp_signature.on_attach({
			doc_lines = 0,
			handler_opts = {
				border = "rounded",
			},
			hint_prefix = "^ ",
			hint_scheme = "DiagnosticHint",
			hi_parameter = "PmenuSel",
			max_width = 4000,
		}, bufnr)

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = bufnr }
		keymap.set("n", "<leader>gd", vim.lsp.buf.declaration, opts)
		--keymap.set('n', '<leader>gt', vim.lsp.buf.definition, opts)
		keymap.set("n", "<leader>k", vim.lsp.buf.hover, opts)
		--keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opts)
		--keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		--keymap.set('n', '<leader>gy', vim.lsp.buf.type_definition, opts)
		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)
		--keymap.set('n', '<leader>gf', vim.lsp.buf.references, opts)
		keymap.set({ "n", "v" }, "<leader>F", function()
			vim.lsp.buf.format({ async = true })
		end, opts)

		keymap.set("v", "<leader>f", function()
			if not client.server_capabilities.documentRangeFormattingProvider then
				vim.print("Range formatting not supported")
				return
			end

			-- Exit selection, needed to set < and > marks
			local escKey = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
			vim.api.nvim_feedkeys(escKey, "nx", false)

			-- Get selection
			local a = vim.api.nvim_buf_get_mark(bufnr, "<")
			local b = vim.api.nvim_buf_get_mark(bufnr, ">")

			vim.lsp.buf.format({ async = true, range = { a, b } })

			-- Restore selection
			vim.api.nvim_feedkeys("gv", "n", false)
		end, opts)
	end,
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local base_config = {
	capabilities = capabilities,
}

local servers = {
	pyright = {},
	tsserver = {
		single_file_support = false,
		root_dir = lsputil.root_pattern("tsconfig.json"),
	},
	bashls = {},
	lua_ls = {},
	clangd = {
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--header-insertion=never",
			"--suggest-missing-includes",
			"--completion-style=detailed",
		},
	},
	gopls = {},
	denols = {
		root_dir = lsputil.root_pattern("deno.json", "deno.jsonc"),
	},
	rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				check = {
					command = "clippy",
				},
			},
		},
	},
}

for lsp, lsp_config in pairs(servers) do
	local config = vim.tbl_deep_extend("force", base_config, lsp_config)
	lspconfig[lsp].setup(config)
end

local mkCheckDeno = function(expect)
	return function(utils)
		return utils.root_has_file("deno.json", "deno.jsonc") == expect
	end
end

local mkCheckYarnPnp = function(expect)
	return function(utils)
		return utils.root_has_file(".pnp.cjs") == expect
	end
end

local mkCond = function(...)
	local condArgs = { ... }

	return function(utils)
		for _, f in ipairs(condArgs) do
			if not f(utils) then
				return false
			end
		end

		return true
	end
end

-- local checkDeno = function(expect)
--     return {
--         condition = function(utils)
--             return utils.root_has_file('deno.json', 'deno.jsonc') == expect
--         end,
--     }
-- end

null_ls.setup({
	sources = {
		-- bash
		null_ls.builtins.code_actions.shellcheck,
		null_ls.builtins.diagnostics.shellcheck,

		-- js/ts
		null_ls.builtins.code_actions.eslint.with({
			condition = mkCond(mkCheckDeno(false), mkCheckYarnPnp(false)),
		}),
		null_ls.builtins.diagnostics.eslint.with({
			condition = mkCond(mkCheckDeno(false), mkCheckYarnPnp(false)),
		}),
		null_ls.builtins.formatting.eslint.with({
			condition = mkCond(mkCheckDeno(false), mkCheckYarnPnp(false)),
		}),

		null_ls.builtins.code_actions.eslint.with({
			command = "yarn",
			args = { "eslint", "-f", "json", "--stdin", "--stdin-filename", "$FILENAME" },
			condition = mkCond(mkCheckDeno(false), mkCheckYarnPnp(true)),
		}),
		null_ls.builtins.diagnostics.eslint.with({
			command = "yarn",
			args = { "eslint", "-f", "json", "--stdin", "--stdin-filename", "$FILENAME" },
			condition = mkCond(mkCheckDeno(false), mkCheckYarnPnp(true)),
		}),
		null_ls.builtins.formatting.eslint.with({
			command = "yarn",
			args = { "eslint", "--fix-dry-run", "-f", "json", "--stdin", "--stdin-filename", "$FILENAME" },
			condition = mkCond(mkCheckDeno(false), mkCheckYarnPnp(true)),
		}),

		-- deno
		null_ls.builtins.diagnostics.deno_lint.with({
			condition = mkCond(mkCheckDeno(true)),
		}),
		null_ls.builtins.formatting.deno_fmt.with({
			condition = mkCond(mkCheckDeno(true)),
		}),

		-- c/cpp
		null_ls.builtins.diagnostics.clang_check,
		null_ls.builtins.formatting.clang_format,

		-- python
		null_ls.builtins.diagnostics.mypy,
		null_ls.builtins.diagnostics.flake8,
		null_ls.builtins.diagnostics.pylint,
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.black,

		-- go
		null_ls.builtins.diagnostics.golangci_lint,

		-- lua
		null_ls.builtins.formatting.stylua,
	},
})

---------------------
-- nvim-treesitter --
---------------------
-- Note: has to be after LSP
-- See:
--   - https://neovim.discourse.group/t/lsp-not-starting-automatically/1886/9
--   - https://github.com/wbthomason/packer.nvim/issues/778
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"cpp",
		"bash",
		"python",
		"typescript",
		"javascript",
		"html",
		"cmake",
		"dockerfile",
		"go",
		"haskell",
		"java",
		"json",
		"latex",
		"lua",
		"make",
		"toml",
		"yaml",
		"tsx",
		"rust",
	},
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = {}, -- list of language that will be disabled
	},
	incremental_selection = {
		enable = false,
	},
	indent = {
		enable = false,
	},
})

--------------------
-- vim-illuminate --
--------------------
require("illuminate").configure({})

----------------
-- nvim-navic --
----------------
navic.setup({
	icons = {
		File = "󰈙 ",
		Module = " ",
		Namespace = "󰌗 ",
		Package = " ",
		Class = "󰌗 ",
		Method = "󰆧 ",
		Property = " ",
		Field = " ",
		Constructor = " ",
		Enum = "󰕘 ",
		Interface = "󰕘 ",
		Function = "󰊕 ",
		Variable = "󰆧 ",
		Constant = "󰏿 ",
		String = "󰀬 ",
		Number = "󰎠 ",
		Boolean = "◩ ",
		Array = "󰅪 ",
		Object = "󰅩 ",
		Key = "󰌋 ",
		Null = "󰟢 ",
		EnumMember = " ",
		Struct = "󰌗 ",
		Event = " ",
		Operator = "󰆕 ",
		TypeParameter = "󰊄 ",
	},
	lsp = {
		auto_attach = false,
		preference = nil,
	},
	highlight = true,
	separator = "  ",
	depth_limit = 0,
	depth_limit_indicator = "..",
	safe_output = true,
	click = false,
})

-------------------
-- nvim-navbuddy --
-------------------
local nvba = require("nvim-navbuddy.actions")
navbuddy.setup({
	window = {
		border = "single",
		size = "60%",
		position = "50%",
		scrolloff = nil,
		sections = {
			left = {
				size = "20%",
				border = nil,
			},
			mid = {
				size = "40%",
				border = nil,
			},
			right = {
				border = nil,
				preview = "leaf",
			},
		},
	},
	node_markers = {
		enabled = true,
		icons = {
			leaf = "  ",
			leaf_selected = " → ",
			branch = " ",
		},
	},
	icons = {
		File = "󰈙 ",
		Module = " ",
		Namespace = "󰌗 ",
		Package = " ",
		Class = "󰌗 ",
		Method = "󰆧 ",
		Property = " ",
		Field = " ",
		Constructor = " ",
		Enum = "󰕘 ",
		Interface = "󰕘 ",
		Function = "󰊕 ",
		Variable = "󰆧 ",
		Constant = "󰏿 ",
		String = "󰀬 ",
		Number = "󰎠 ",
		Boolean = "◩ ",
		Array = "󰅪 ",
		Object = "󰅩 ",
		Key = "󰌋 ",
		Null = "󰟢 ",
		EnumMember = " ",
		Struct = "󰌗 ",
		Event = " ",
		Operator = "󰆕 ",
		TypeParameter = "󰊄 ",
	},
	use_default_mappings = false, -- If set to false, only mappings set
	-- by user are set. Else default
	-- mappings are used for keys
	-- that are not set by user
	mappings = {
		["<esc>"] = nvba.close(), -- Close and cursor to original location
		["q"] = nvba.close(),

		["<down>"] = nvba.next_sibling(), -- down
		["<up>"] = nvba.previous_sibling(), -- up

		["<left>"] = nvba.parent(), -- Move to left panel
		["<right>"] = nvba.children(), -- Move to right panel
		["0"] = nvba.root(), -- Move to first panel

		["v"] = nvba.visual_name(), -- Visual selection of name
		["V"] = nvba.visual_scope(), -- Visual selection of scope

		["y"] = nvba.yank_name(), -- Yank the name to system clipboard '+
		["Y"] = nvba.yank_scope(), -- Yank the scope to system clipboard '+

		-- ['i'] = nvba.insert_name(),      -- Insert at start of name
		-- ['I'] = nvba.insert_scope(),     -- Insert at start of scope

		-- ['a'] = nvba.append_name(),      -- Insert at end of name
		-- ['A'] = nvba.append_scope(),     -- Insert at end of scope

		["r"] = nvba.rename(), -- Rename currently focused symbol

		-- ['d'] = nvba.delete(),           -- Delete scope

		-- ['f'] = nvba.fold_create(),      -- Create fold of current scope
		-- ['F'] = nvba.fold_delete(),      -- Delete fold of current scope

		-- ['c'] = nvba.comment(),          -- Comment out current scope

		["<enter>"] = nvba.select(), -- Goto selected symbol
		["o"] = nvba.select(),

		-- ['J'] = nvba.move_down(),        -- Move focused node down
		-- ['K'] = nvba.move_up(),          -- Move focused node up

		["t"] = nvba.telescope({ -- Fuzzy finder at current level.
			layout_config = { -- All options that can be
				height = 0.60, -- passed to telescope.nvim's
				width = 0.60, -- default can be passed here.
				prompt_position = "top",
				preview_width = 0.50,
			},
			layout_strategy = "horizontal",
		}),

		["g?"] = nvba.help(), -- Open mappings help window
	},
	lsp = {
		auto_attach = false, -- If set to true, you don't need to manually use attach function
		preference = nil, -- list of lsp server names in order of preference
	},
	source_buffer = {
		follow_node = true, -- Keep the current node in focus on the source buffer
		highlight = true, -- Highlight the currently focused node
		reorient = "smart", -- 'smart', 'top', 'mid' or 'none'
		scrolloff = nil, -- scrolloff value when navbuddy is open
	},
})

--------------------
-- telescope.nvim --
--------------------
local telescope = require("telescope")
local telescope_actions = require("telescope.actions")

telescope.load_extension("fzf")
telescope.load_extension("ui-select")

telescope.setup({
	defaults = {
		file_ignore_patterns = {
			"%.git\\",
			"node%_modules\\",
			"%.cache\\",
			"%.obj$",
			"%.tlog$",
		},
		mappings = {
			i = {
				["<esc>"] = telescope_actions.close,
				["<C-u>"] = false,
			},
		},
		layout_strategy = "vertical",
	},
	pickers = {
		buffers = {
			theme = "dropdown",
		},
		code_actions = {
			theme = "cursor",
		},
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown(),
		},
	},
})

local builtin = require("telescope.builtin")

keymap.set("n", "<leader>ff", builtin.find_files, {})
keymap.set("n", "<leader>fg", builtin.live_grep, {})
keymap.set("n", "<leader>b", builtin.buffers, {})
keymap.set("n", "<leader>fh", builtin.help_tags, {})
keymap.set("n", "<leader>gf", builtin.lsp_references, {})
keymap.set("n", "<leader>gt", builtin.lsp_definitions, {})
keymap.set("n", "<leader>gi", builtin.lsp_implementations, {})
keymap.set("n", "<leader>gy", builtin.lsp_type_definitions, {})
keymap.set("n", "<leader>s", builtin.lsp_document_symbols, {})
keymap.set("n", "<leader>v", navbuddy.open, {})
--keymap.set('n', '<leader>a', builtin.lsp_code_actions, {})

---------------------------
-- indent-blankline.nvim --
---------------------------
vim.cmd([[
    highlight IndentBlanklineChar guifg=#4C4C4C gui=nocombine
]])

require("ibl").setup({
	indent = { char = "¦", tab_char = "¦" },
	scope = { enabled = true, show_start = true },
})

--------------
-- hop.nvim --
--------------
local hop = require("hop")
local hopdir = require("hop.hint").HintDirection

hop.setup()

keymap.set("", "f", function()
	hop.hint_char1({ direction = hopdir.AFTER_CURSOR, current_line_only = true })
end, { remap = true })
keymap.set("", "F", function()
	hop.hint_char1({ direction = hopdir.BEFORE_CURSOR, current_line_only = true })
end, { remap = true })
keymap.set("", "t", function()
	hop.hint_char1({ direction = hopdir.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, { remap = true })
keymap.set("", "T", function()
	hop.hint_char1({ direction = hopdir.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, { remap = true })
keymap.set("", "s", function()
	hop.hint_words()
end, { remap = true })
keymap.set("", "S", function()
	hop.hint_anywhere()
end, { remap = true })

---------------
-- neoscroll --
---------------
local neoscroll = require("neoscroll")
neoscroll.setup({})

-----------------
-- feline.nvim --
-----------------
local feline = require("feline")

local winbar = { active = { {}, {} } }

table.insert(winbar.active[1], {
	provider = navic.get_location,
	enabled = navic.is_available,
})

feline.setup({})
feline.winbar.setup({ components = winbar })
-- feline.statuscolumn.setup {}

----------------
-- localvimrc --
----------------
vim.cmd([[
    let g:localvimrc_sandbox = 0
    let g:localvimrc_whitelist = [
    \ ]
]])
