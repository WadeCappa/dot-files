
local plugins = {
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"gopls",
				"pyright",
			},
		},
	},
	{"mason-org/mason-lspconfig.nvim"},
	{"neovim/nvim-lspconfig"},
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
