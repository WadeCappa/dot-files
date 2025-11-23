
-- theming
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme catppuccin]])

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

---- Language servers ----
-- setup mason
require("mason-lspconfig").setup({
  ensure_installed = { 
		"pyright", 
		"gopls", 
	},  
})

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

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local api = require('nvim-tree.api')
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
    vim.keymap.set('n', '<Leader>e', api.tree.toggle, { desc = 'Toggle NvimTree' })
  end,
})

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

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
