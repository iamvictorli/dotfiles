-- From https://github.com/nvim-lua/kickstart.nvim. current commit is 4916072854d01d0503821b7f3061daeb381f0441
-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	is_bootstrap = true
	vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd([[packadd packer.nvim]])
end

require("packer").startup(function(use)
	-- Package manager
	use("wbthomason/packer.nvim")

	use({ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		requires = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			"j-hui/fidget.nvim",

			-- Additional lua configuration, makes nvim stuff amazing
			"folke/neodev.nvim",
		},
	})

	use({ -- Autocompletion
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
		},
	})

	use({ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		run = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
	})

	use({ -- Additional text objects via treesitter
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
	})
	use({ "JoosepAlviste/nvim-ts-context-commentstring" })

	-- Git related plugins
	use("tpope/vim-fugitive")
	use("tpope/vim-rhubarb")
	use("lewis6991/gitsigns.nvim")

	use("catppuccin/nvim") -- Catppuccin theme
	use("nvim-lualine/lualine.nvim") -- Fancier statusline
	use("lukas-reineke/indent-blankline.nvim") -- Add indentation guides even on blank lines
	use("numToStr/Comment.nvim") -- "gc" to comment visual regions/lines
	use("tpope/vim-sleuth") -- Detect tabstop and shiftwidth automatically

	-- Fuzzy Finder (files, lsp, etc)
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x", requires = { "nvim-lua/plenary.nvim" } })

	-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make", cond = vim.fn.executable("make") == 1 })

	-- File browser for telescope
	use({ "nvim-telescope/telescope-file-browser.nvim" })

	-- Vim surround plugin
	use("tpope/vim-surround")

	-- auto pairs/tag plugins
	use("windwp/nvim-autopairs")
	use("windwp/nvim-ts-autotag")

	-- formatting & linting
	use("jose-elias-alvarez/null-ls.nvim")

	-- highlights colors
	use("norcalli/nvim-colorizer.lua")

	-- github copilot
	-- :Copilot setup
	use("github/copilot.vim")

	use("numToStr/Navigator.nvim")

	-- -- interesting plugins to checkout
	-- https://github.com/mfussenegger/nvim-dap
	-- https://github.com/jose-elias-alvarez/typescript.nvim
	-- https://github.com/kevinhwang91/nvim-ufo
	-- https://github.com/akinsho/bufferline.nvim
	-- https://github.com/nvim-tree/nvim-tree.lua
	-- https://github.com/nvim-tree/nvim-web-devicons
	-- https://github.com/akinsho/toggleterm.nvim
	-- https://github.com/ahmedkhalf/project.nvim
	-- https://github.com/lewis6991/impatient.nvim
	-- https://github.com/goolord/alpha-nvim
	-- https://github.com/folke/which-key.nvim
	-- https://github.com/moll/vim-bbye

	-- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
	local has_plugins, plugins = pcall(require, "custom.plugins")
	if has_plugins then
		plugins(use)
	end

	if is_bootstrap then
		require("packer").sync()
	end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
	print("==================================")
	print("    Plugins are being installed")
	print("    Wait until Packer completes,")
	print("       then restart nvim")
	print("==================================")
	return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	command = "source <afile> | silent! LspStop | silent! LspStart | PackerCompile",
	group = packer_group,
	pattern = vim.fn.expand("$MYVIMRC"),
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- highlights search matches
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Show relative line numbers
vim.o.relativenumber = true

-- highlight current line
vim.o.cursorline = true

-- number of lines above or below cursor
vim.o.scrolloff = 8

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd([[colorscheme catppuccin-frappe]])

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- splitting a window will put the new window right of the current one
vim.o.splitright = true

-- splitting a window will put the new window below the current one
vim.o.splitbelow = true

-- more space in the neovim command for displaying messages
vim.o.cmdheight = 2

-- popup menu height
vim.o.pumheight = 10

-- highlighted column on line 80
vim.wo.colorcolumn = "80"

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- other options commented --
-- vim.o.clipboard = 'unnamedplus' -- allows neovim to access the system clipboard
-- vim.o.fileencoding = 'utf-8' -- encoding written to a file
-- vim.o.writebackup = false -- if a file is being editted by another program (or was written to file when editting with another program), it is not allowed to be editted
-- vim.o.lazyredraw = true -- redraw only when we need to

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "ss", ":sp<CR>", { silent = true, desc = "[S]plit[S] window" })
vim.keymap.set("n", "sv", ":vsp<CR>", { silent = true, desc = "[S]plit [V]ertically window" })
vim.keymap.set("n", "sc", "<C-w>c", { silent = true, desc = "[S]plit [C]lose window" })

-- window navigation
require("Navigator").setup()
vim.keymap.set("n", "<C-h>", "<CMD>NavigatorLeft<CR>", { silent = true, desc = "go to left window or tmux pane" })
vim.keymap.set("n", "<C-j>", "<CMD>NavigatorDown<CR>", { silent = true, desc = "go to lower window or tmux pane" })
vim.keymap.set("n", "<C-k>", "<CMD>NavigatorUp<CR>", { silent = true, desc = "go to upper window or tmux pane" })
vim.keymap.set("n", "<C-l>", "<CMD>NavigatorRight<CR>", { silent = true, desc = "go to right window or tmux pane" })

-- window resize
vim.keymap.set("n", "<leader>h", ":vertical resize -2<CR>", { silent = true, desc = "decrease window width" })
vim.keymap.set("n", "<leader>j", ":resize +2<CR>", { silent = true, desc = "increase window height" })
vim.keymap.set("n", "<leader>k", ":resize -2<CR>", { silent = true, desc = "decrease window height" })
vim.keymap.set("n", "<leader>l", ":vertical resize +2<CR>", { silent = true, desc = "increase window height" })
vim.keymap.set("n", "<leader>we", "<C-w>=", { silent = true, desc = "make [W]indow [E]qual splits" })

-- buffer navigation
vim.keymap.set("n", "<leader>b", ":bnext<CR>", { silent = true, desc = "move to next [B]uffer" })
vim.keymap.set("n", "<leader>B", ":bprevious<CR>", { silent = true, desc = "move to previous [B]uffer" })

-- navigation
vim.keymap.set("n", "n", "nzzzv", { silent = true, desc = "keeps cursor centered when pressing n" })
vim.keymap.set("n", "N", "Nzzzv", { silent = true, desc = "keeps cursor centered when pressing N" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, desc = "stays on middle screen while <C-d>" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true, desc = "stays on middle screen while <C-u>" })

-- yanks
vim.keymap.set("n", "Y", "y$", { silent = true, desc = "yanks the rest of the line" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { silent = true, desc = "[Y]anks to system clipboard" })

vim.keymap.set("n", "gV", "`[v`]", { silent = true, desc = "highlights last inserted text" })

vim.keymap.set("n", "J", "mzJ`z", { silent = true, desc = "removes and appends next line to current cursor line" })

vim.keymap.set("n", "x", '"_x', { silent = true, desc = "deleting a single character without copying to register" })

-- Visual
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "move text down in visual mode" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "move text up in visual mode" })
vim.keymap.set("v", "<", "<gv", { silent = true, desc = "indent less" })
vim.keymap.set("v", ">", ">gv", { silent = true, desc = "indent more" })

vim.keymap.set("x", "<leader>p", [["_dP]], { silent = true, desc = "[P]asting text does not override register" })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- [[ PLUGINS ]]

require("catppuccin").setup({
	flavour = "frappe",
	background = {
		dark = "frappe",
	},
	dim_inactive = {
		enabled = true,
		shade = "dark",
		percentage = 0.15,
	},
	cmp = true,
	fidget = true,
	gitsigns = true,
	mason = true,
	telescope = true,
	treesitter = true,
	indent_blankline = {
		enabled = true,
		colored_indent_levels = false,
	},
})

-- colorizer
require("colorizer").setup()

-- autopairs
require("nvim-autopairs").setup({
	check_ts = true,
	ts_config = {
		lua = { "string", "source" }, -- it will not add a pair on that treesitter node
		javascript = { "string", "template_string" },
		java = false,
	},
	disable_filetype = { "TelescopePrompt", "spectre_panel" },
	fast_wrap = {},
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- LuaLine
-- Set lualine as statusline
-- See `:help lualine.txt`
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "catppuccin",
		component_separators = "|",
		section_separators = "",
	},
})

-- Enable Comment.nvim
require("Comment").setup({
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
vim.keymap.set("n", "<leader>/", "<Plug>(comment_toggle_linewise_current)", { desc = "Comment current line" })
vim.keymap.set("v", "<leader>/", "<Plug>(comment_toggle_linewise_visual)", { desc = "Comment visual block" })

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require("indent_blankline").setup({
	char = "┊",
	show_trailing_blankline_indent = false,
})

-- Gitsigns
-- See `:help gitsigns.txt`
require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local actions = require("telescope.actions")

require("telescope").setup({
	defaults = {
		prompt_prefix = " ",
		selection_caret = " ",
		path_display = { "smart" },
		mappings = {
			i = {
				["<C-j>"] = actions.cycle_history_next,
				["<C-k>"] = actions.cycle_history_prev,

				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,

				["<C-c>"] = actions.close,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,

				["<CR>"] = actions.select_default,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<C-l>"] = actions.complete_tag,
				["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
			},
			n = {
				["<esc>"] = actions.close,
				["<CR>"] = actions.select_default,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

				["j"] = actions.move_selection_next,
				["k"] = actions.move_selection_previous,
				["H"] = actions.move_to_top,
				["M"] = actions.move_to_middle,
				["L"] = actions.move_to_bottom,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,
				["gg"] = actions.move_to_top,
				["G"] = actions.move_to_bottom,

				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,

				["?"] = actions.which_key,
			},
		},
		pickers = {},
		extensions = {
			filebrowser = {
				theme = "dropdown",
				-- disables netrw and use telescope-file-browser in its place
				hijack_netrw = true,
			},
		},
	},
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "file_browser")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").oldfiles, { desc = "[S]earch [R]ecently old files" })
vim.keymap.set("n", "<leader>sR", require("telescope.builtin").registers, { desc = "[S]earch [R]egisters" }) -- <CR> pastes the contents of register
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>s/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>st", require("telescope.builtin").live_grep, { desc = "[S]earch [T]ext" })
vim.keymap.set("n", "<leader>sgb", require("telescope.builtin").git_branches, { desc = "[S]earch [G]it [B]ranches" }) -- <CR> to checkout branch
vim.keymap.set("n", "<leader>sgf", require("telescope.builtin").git_files, { desc = "[S]earch [G]it [F]iles" }) -- <CR> to check file
vim.keymap.set("n", "<leader>sgc", require("telescope.builtin").git_commits, { desc = "[S]earch [G]it [C]commits" }) -- <CR> to checkout commit
vim.keymap.set("n", "<leader>sgs", require("telescope.builtin").git_status, { desc = "[S]earch [G]it [S]tatus" })
vim.keymap.set("n", "<leader>sgS", require("telescope.builtin").git_stash, { desc = "[S]earch [G]it [S]tash" }) -- <CR> to apply stash
vim.keymap.set("n", "<leader>sc", require("telescope.builtin").commands, { desc = "[S]earch [C]ommands" }) -- <CR> runs command
vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>pp", function()
	require("telescope").extensions.file_browser.file_browser({
		respect_gitignore = false,
		hidden = true,
		grouped = true,
		previewer = false,
		initial_mode = "normal",
		layout_config = { height = 40 },
	})
end, { desc = "[P]roject [P]ath" })
vim.keymap.set("n", "<leader>rp", function()
	require("telescope").extensions.file_browser.file_browser({
		path = "%:p:h",
		cwd = vim.fn.expand("%:p:h"),
		respect_gitignore = false,
		hidden = true,
		grouped = true,
		previewer = false,
		initial_mode = "normal",
		layout_config = { height = 40 },
	})
end, { desc = "[R]elative [P]ath" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
	-- from nvim-ts-auto plugin
	autotag = {
		enable = true,
	},
	-- from nvim-ts-context-commentstring
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = {
		"astro",
		"bash",
		"comment",
		"c",
		"cmake",
		"cpp",
		"css",
		"diff",
		"dockerfile",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"go",
		"graphql",
		"help",
		"html",
		"http",
		"javascript",
		"jsdoc",
		"json",
		"json5",
		"jsonc",
		"lua",
		"make",
		"php",
		"phpdoc",
		"prisma",
		"python",
		"rust",
		"scss",
		"svelte",
		"terraform",
		"tsx",
		"todotxt",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"vue",
		"yaml",
	},

	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "" }, -- list of languages that will be disabled
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true, disable = { "yaml" } },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<c-space>",
			node_incremental = "<c-space>",
			scope_incremental = "<c-s>",
			node_decremental = "<c-backspace>",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>A"] = "@parameter.inner",
			},
		},
	},
})

-- Diagnostic keymaps
-- TODO: set description
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "gl", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--  https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
	astro = {},
	bashls = {},
	cssls = {},
	cssmodules_ls = {},
	dockerls = {},
	emmet_ls = {},
	eslint = {},
	graphql = {},
	html = {},
	jsonls = {},
	prismals = {},
	sqlls = {},
	sumneko_lua = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
	svelte = {},
	tailwindcss = {},
	tsserver = {},
	vuels = {},
	yamlls = {},
}

-- Setup neovim lua configuration
require("neodev").setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		})
	end,
})

-- Turn on lsp status information
require("fidget").setup({
	window = {
		blend = 0,
	},
})

-- nvim-cmp setup
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		documentation = cmp.config.window.bordered(),
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}), -- get rid of completions
		-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		-- disable completion with tab for github copilot
		["<Tab>"] = nil,
		["<S-Tab>"] = nil,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "nvim_lua" },
	},
})

-- null ls
local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- :Mason to install formatters and diagnostics
null_ls.setup({
	debug = false,
	sources = {
		null_ls.builtins.formatting.fixjson,
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.eslint_d.with({ -- js/ts linter
			diagnostics_format = "[eslint] #{m}\n(#{c})",
		}),
		null_ls.builtins.diagnostics.jsonlint,
		null_ls.builtins.diagnostics.tsc,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})

vim.api.nvim_create_user_command("DisableLspFormatting", function()
	vim.api.nvim_clear_autocmds({ group = augroup, buffer = 0 })
end, { nargs = 0 })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
