---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
	local conform = require("conform")
	for i = 1, select("#", ...) do
		local formatter = select(i, ...)
		if conform.get_formatter_info(formatter, bufnr).available then
			return formatter
		end
	end
	return select(1, ...)
end

return {
	-- LSP BEGIN {{{
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

			lspconfig.biome.setup({})
			lspconfig.lua_ls.setup({
				capabilities = cmp_capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
					},
				},
			})
			lspconfig.tsserver.setup({
				init_options = {
					preferences = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
						importModuleSpecifierPreference = "relative",
					},
				},
				capabilities = cmp_capabilities,
				on_attach = function(client)
					client.server_capabilities.documentFormattingProvider = false
				end,
			})
			lspconfig.eslint.setup({
				capabilities = cmp_capabilities,
				on_attach = function(client)
					client.server_capabilities.documentFormattingProvider = true
				end,
			})
			lspconfig.rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						checkOnSave = true,
						check = {
							command = "clippy",
						},
					},
				},
				on_attach = function(_, bufnr)
					vim.lsp.inlay_hint.enable(true, { bufnr })
				end,
			})
			lspconfig.bashls.setup({})
			lspconfig.mdx_analyzer.setup({})
			lspconfig.jsonls.setup({
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})
			lspconfig.yamlls.setup({
				settings = {
					yaml = {
						schemaStore = {
							-- You must disable built-in schemaStore support if you want to use
							-- this plugin and its advanced options like `ignore`.
							enable = false,
							-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
							url = "",
						},
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			})
			lspconfig.tailwindcss.setup({
				init_options = {
					eelixir = "html-eex",
					eruby = "erb",
					rust = "html",
				},
			})
		end,
		dependencies = {
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"b0o/schemastore.nvim",
		},
	},
	{
		"j-hui/fidget.nvim",
		branch = "legacy",
		event = "LspAttach",
		opts = {},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	--- LSP END }}}
	-- AUTOINSTALL BEGIN {{{
	{
		"williamboman/mason.nvim",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				automatic_installation = true,
				ensure_installed = {
					"eslint",
					"tsserver",
					"lua_ls",
				},
			})
			require("mason-lspconfig").setup_handlers({
				function(server_name) -- default handler (optional)
					local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
					require("lspconfig")[server_name].setup({ capabilities = cmp_capabilities })
				end,
			})
		end,
	},
	-- END }}}
	-- COMPLETION BEGIN {{{
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"FelipeLema/cmp-async-path",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local cmp = require("cmp")
			local ls = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()

			---@diagnostic disable-next-line: missing-fields
			cmp.setup({
				enabled = true,
				snippet = {
					expand = function(args)
						ls.lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm(), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<Tab>"] = cmp.mapping.confirm(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "async_path" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
	-- COMPLETION END }}}
	-- TREESITTER BEGIN {{{
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			vim.o.foldmethod = "expr"
			vim.o.foldexpr = "nvim_treesitter#foldexpr()"
			vim.o.foldenable = false

			require("nvim-treesitter.configs").setup({
				sync_install = false,
				auto_install = true,
				ignore_install = {},
				modules = {},
				ensure_installed = "all",
				highlight = {
					enable = true,
				},
				indent = {
					enable = false,
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
							-- You can also use captures from other query groups like `locals.scm`
							["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
						},
						-- If you set this to `true` (default is `false`) then any textobject is
						-- extended to include preceding or succeeding whitespace. Succeeding
						-- whitespace has priority in order to act similarly to eg the built-in
						-- `ap`.
						include_surrounding_whitespace = true,
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist

						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = { query = "@class.outer", desc = "Next class start" },
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
					},
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "vv",
						node_incremental = "+",
						node_decremental = "=",
					},
				},
			})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"IndianBoy42/tree-sitter-just",
		},
	},
	{
		"IndianBoy42/tree-sitter-just",
		config = true,
	},
	-- END }}}
	-- FORMATTING BEGIN {{{
	{
		"stevearc/conform.nvim",
		config = function()
			local es_formatters = { "biome", "eslint_d", "eslint", lsp_format = "fallback", stop_after_first = true }
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = es_formatters,
					typescript = es_formatters,
					typescriptreact = es_formatters,
					astro = { "eslint_d" },
					json = function(bufnr)
						return { "jq", first(bufnr, "prettierd", "prettier") }
					end,
					rust = { "rustfmt" },
					bash = { "beautysh" },
					sh = { "beautysh" },
					zsh = { "beautysh" },
					sql = { "sqlfluff" },
					toml = { "taplo" },
					terraform = { "terraform_fmt" },
				},
				formatters = {
					rustfmt = {
						command = "rustfmt",
						args = { "--edition=2021", "--emit=stdout" },
					},
					terraform_fmt = {
						command = "tofu",
						args = { "fmt", "-no-color", "-" },
					},
					biome = {
						cwd = require("conform.util").root_file({ "biome.json", "biome.jsonc" }),
						require_cwd = true,
					},
				},
			})
		end,
	},
	-- }}}
	-- TESTING & DEBUGGING {{{
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-jest",
			"marilari88/neotest-vitest",
			"rouge8/neotest-rust",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-jest")({}),
					require("neotest-rust"),
					require("neotest-vitest"),
				},
			})
		end,
	},
	-- }}}
	-- MISC BEGIN {{{
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = true,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	},
	{
		"pest-parser/pest.vim",
		config = true,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"windwp/nvim-ts-autotag",
		opts = {},
	},
	-- END }}}
}
