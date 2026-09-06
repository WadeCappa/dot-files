
local plugins = {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		-- NOTE: `ensure_installed` belongs here, not on mason.nvim itself.
		-- mason.nvim's setup() has no such option and silently ignores it,
		-- which is why gopls/pyright/clangd were never actually installed
		-- even though they were listed under mason.nvim's opts before.
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"gopls",
				"pyright",
				"clangd",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Add cmp_nvim_lsp capabilities settings to lspconfig
			-- This should be executed before you configure any language server
			local lspconfig_defaults = require('lspconfig').util.default_config
			lspconfig_defaults.capabilities = vim.tbl_deep_extend(
				'force',
				lspconfig_defaults.capabilities,
				require('cmp_nvim_lsp').default_capabilities()
			)

			-- mason-lspconfig's own setup({ ensure_installed = ... }) is called
			-- automatically by lazy.nvim from its `opts` above, and it runs
			-- before this config() since nvim-lspconfig depends on it.

			-- golang
			vim.lsp.config('gopls', {
				settings = {
					gopls = {
						completeUnimported = true,
					},
				},
			})
			vim.lsp.enable('gopls')

			-- python
			vim.lsp.config('pyright', {
				settings = {
					pyright = {
						python = {
							analysis = {
								autoImportCompletions = true,
								typeCheckingMode = "strict",  -- "off", "basic", or "strict"
								diagnosticMode = "workspace",  -- options: "openFilesOnly" or "workspace"
							},
						},
					},
				},
			})
			vim.lsp.enable('pyright')

			-- C/C++
			-- NOTE: clangd works out of the box for single files, but for real
			-- projects it needs a compile_commands.json (or a compile_flags.txt)
			-- to know your include paths/defines. How you generate that depends
			-- on the build system you end up standardizing on, e.g.:
			--   - CMake:    set(CMAKE_EXPORT_COMPILE_COMMANDS ON) and symlink the
			--               generated compile_commands.json into the project root
			--   - Makefile: generate one with `bear -- make` or `compiledb make`
			-- Revisit this once that decision is made.
			vim.lsp.config('clangd', {
				cmd = { "clangd", "--background-index", "--clang-tidy" },
			})
			vim.lsp.enable('clangd')

			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(event)
					local opts = {buffer = event.buf}

					vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
					vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
					vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
					vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
					vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
					vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
					vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
					vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
					vim.keymap.set({'n', 'x'}, '<leader>fm', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
					vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
				end,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local cmp = require('cmp')
			cmp.setup({
				sources = {
					{name = 'nvim_lsp'},
				},
				snippet = {
					expand = function(args)
						-- You need Neovim v0.10 to use vim.snippet
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({}),
			})
		end,
	},
	{"hrsh7th/cmp-nvim-lsp"},
}
return plugins
