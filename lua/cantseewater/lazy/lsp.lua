
local plugins = {
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"gopls",
				"delve",
			},
		},
	},
	{"mason-org/mason-lspconfig.nvim"},
	{"neovim/nvim-lspconfig"},
	{"hrsh7th/nvim-cmp"},
	{"hrsh7th/cmp-nvim-lsp"},
}
return plugins
